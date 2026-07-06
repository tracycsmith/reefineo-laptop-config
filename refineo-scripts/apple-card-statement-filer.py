#!/usr/bin/env python3
# apple-card-statement-filer.py
"""
@file       apple-card-statement-filer.py
@description Scans ~/Downloads/Personal for Apple Card statement PDFs, renames
             them to YYYY-MM-DD-Apple-Card-Statement.pdf using the last day of
             the statement month, and moves them to the AppleCard archive
             organized by year. Idempotent and safe to run repeatedly.

             Triggered automatically by LaunchAgent
             com.refineo.apple-card-filer when files land in the watched
             directory. Can also be run manually for ad-hoc cleanup.

             Logs to ~/Library/Logs/apple-card-filer.log
"""

import calendar
import json
import logging
import re
import shutil
import sys
from datetime import datetime
from logging.handlers import RotatingFileHandler
from pathlib import Path


# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

HOME = Path.home()

CONFIG = {
    "source_dir": HOME / "Downloads" / "Personal",
    "dest_base": HOME / "Documents" / "Obsidian" / "Personal"
                 / "30 Finance" / "Records" / "Statements" / "AppleCard",
    "log_path": HOME / "Library" / "Logs" / "apple-card-filer.log",
    "status_path": HOME / "Library" / "Application Support" / "Refineo"
                   / "Scripts" / "apple-card-status.json",
    "filename_pattern": re.compile(
        r"^Apple Card Statement - (\w+) (\d{4})\.pdf$"
    ),
    "archived_pattern": re.compile(
        r"^(\d{4})-(\d{2})-(\d{2})-Apple-Card-Statement\.pdf$"
    ),
}

MONTHS = {
    "January": 1, "February": 2, "March": 3, "April": 4,
    "May": 5, "June": 6, "July": 7, "August": 8,
    "September": 9, "October": 10, "November": 11, "December": 12,
}


# ---------------------------------------------------------------------------
# Logger
# ---------------------------------------------------------------------------

def build_logger(log_path: Path = CONFIG["log_path"]) -> logging.Logger:
    """Create a namespaced rotating logger for AppleCardFiler."""
    log_path.parent.mkdir(parents=True, exist_ok=True)
    logger = logging.getLogger("AppleCardFiler")
    if logger.handlers:
        return logger
    logger.setLevel(logging.INFO)
    handler = RotatingFileHandler(
        log_path, maxBytes=512_000, backupCount=3, encoding="utf-8"
    )
    handler.setFormatter(logging.Formatter(
        "%(asctime)s [%(levelname)s] %(name)s :: %(message)s"
    ))
    logger.addHandler(handler)
    return logger


log = build_logger()


# ---------------------------------------------------------------------------
# Core helpers
# ---------------------------------------------------------------------------

def parse_statement_filename(name: str):
    """Return (year, month) for a recognized Apple Card filename, else None."""
    pattern = CONFIG["filename_pattern"]
    match = pattern.match(name)
    if not match:
        return None
    month_name, year_str = match.group(1), match.group(2)
    if month_name not in MONTHS:
        return None
    return int(year_str), MONTHS[month_name]


def build_target_path(year: int, month: int,
                      dest_base: Path = CONFIG["dest_base"]) -> Path:
    """Return the canonical archive path for a given statement year/month."""
    last_day = calendar.monthrange(year, month)[1]
    new_name = f"{year:04d}-{month:02d}-{last_day:02d}-Apple-Card-Statement.pdf"
    return dest_base / str(year) / new_name


def file_one_statement(source_file: Path) -> str:
    """File a single statement PDF. Returns status string for the summary."""
    parsed = parse_statement_filename(source_file.name)
    if not parsed:
        return "ignored"

    year, month = parsed
    target = build_target_path(year, month)

    if target.exists():
        log.warning("Target already exists, skipping: %s", target)
        return "skipped_exists"

    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        shutil.move(str(source_file), str(target))
    except OSError as err:
        log.error("Move failed for %s :: %s", source_file.name, err)
        return "error"

    log.info("Filed: %s -> %s", source_file.name, target)
    return "moved"


# ---------------------------------------------------------------------------
# Status snapshot
# ---------------------------------------------------------------------------

def _compute_expected_by_year(by_year: dict, oldest_year: int,
                               oldest_month: int, today: datetime) -> dict:
    """For each archived year, compute how many statements SHOULD exist.

    - First year: months from oldest_month through December (e.g. May start = 8)
    - Past complete years: 12
    - Current year: months whose statements should have been released by today
      (a statement for month M is expected by the 10th of M+1; before then we
      give the previous statement another grace day)
    """
    expected: dict[str, int] = {}

    if today.day >= 10:
        current_year_through_month = today.month - 1
    else:
        current_year_through_month = today.month - 2
    current_year_through_month = max(0, current_year_through_month)

    for year_str in by_year.keys():
        year = int(year_str)
        if year < oldest_year:
            expected[year_str] = 0
            continue
        if year == oldest_year and year == today.year:
            # First year IS current year
            expected[year_str] = max(0, current_year_through_month - oldest_month + 1)
        elif year == oldest_year:
            expected[year_str] = 13 - oldest_month
        elif year == today.year:
            expected[year_str] = current_year_through_month
        else:
            expected[year_str] = 12

    return expected


def scan_archive(dest_base: Path = CONFIG["dest_base"]) -> dict:
    """Walk the archive and return aggregate stats for the status widget."""
    pattern = CONFIG["archived_pattern"]
    by_year: dict[str, int] = {}
    newest: tuple[str, str] | None = None  # (year, filename)
    oldest_year_month: tuple[int, int] | None = None

    if not dest_base.exists():
        return {"total_statements": 0, "by_year": {}, "expected_by_year": {},
                "newest_archived": None, "newest_archived_year": None}

    for year_dir in sorted(dest_base.iterdir()):
        if not year_dir.is_dir():
            continue
        count = 0
        for entry in sorted(year_dir.iterdir()):
            m = pattern.match(entry.name)
            if not m:
                continue
            count += 1
            year_i, month_i = int(m.group(1)), int(m.group(2))
            if oldest_year_month is None or (year_i, month_i) < oldest_year_month:
                oldest_year_month = (year_i, month_i)
            if newest is None or entry.name > newest[1]:
                newest = (year_dir.name, entry.name)
        if count:
            by_year[year_dir.name] = count

    expected_by_year: dict[str, int] = {}
    if oldest_year_month:
        expected_by_year = _compute_expected_by_year(
            by_year, oldest_year_month[0], oldest_year_month[1], datetime.now()
        )

    return {
        "total_statements": sum(by_year.values()),
        "by_year": by_year,
        "expected_by_year": expected_by_year,
        "newest_archived": newest[1] if newest else None,
        "newest_archived_year": newest[0] if newest else None,
    }


def write_status_snapshot(summary: dict, last_filed: dict | None) -> None:
    """Write a JSON snapshot for the Cowork status widget. Best-effort only."""
    path = CONFIG["status_path"]
    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        snapshot = {
            "last_run_iso": datetime.now().isoformat(timespec="seconds"),
            "last_run_summary": summary,
            "last_filed": last_filed,
            "archive": scan_archive(),
        }
        path.write_text(json.dumps(snapshot, indent=2), encoding="utf-8")
    except OSError as err:
        log.warning("Status snapshot write failed :: %s", err)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def run(source_dir: Path = CONFIG["source_dir"]) -> dict:
    """Scan source_dir and file any Apple Card statements found."""
    summary = {"moved": 0, "skipped_exists": 0, "error": 0, "ignored": 0}
    last_filed = None

    if not source_dir.exists():
        log.error("Source directory missing: %s", source_dir)
        write_status_snapshot(summary, last_filed)
        return summary

    for entry in sorted(source_dir.iterdir()):
        if not entry.is_file():
            continue
        original_name = entry.name
        result = file_one_statement(entry)
        summary[result] = summary.get(result, 0) + 1
        if result == "moved":
            parsed = parse_statement_filename(original_name)
            if parsed:
                year, month = parsed
                last_filed = {
                    "original_name": original_name,
                    "archived_path": str(build_target_path(year, month)),
                    "filed_at_iso": datetime.now().isoformat(timespec="seconds"),
                }

    if summary["moved"] or summary["error"] or summary["skipped_exists"]:
        log.info(
            "Run complete :: moved=%d skipped_exists=%d errors=%d ignored=%d",
            summary["moved"], summary["skipped_exists"],
            summary["error"], summary["ignored"],
        )

    write_status_snapshot(summary, last_filed)
    return summary


def main_wrapper() -> int:
    """Trigger-safe wrapper. Returns process exit code."""
    try:
        summary = run()
        return 0 if summary["error"] == 0 else 1
    except Exception as err:
        log.exception("Unhandled error in main_wrapper :: %s", err)
        return 2


if __name__ == "__main__":
    sys.exit(main_wrapper())
