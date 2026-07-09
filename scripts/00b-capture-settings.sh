#!/bin/zsh
# scripts/00b-capture-settings.sh
# @file 00b-capture-settings.sh
# @description Run ON THE OLD LAPTOP. Snapshots macOS system/app preferences
#              (text replacements, keyboard shortcuts, Finder/Dock/trackpad,
#              screenshots, login items, and the full defaults space) into
#              exports/macos-settings/ so they can be re-applied DELIBERATELY
#              on the new machine — see docs/macos-settings.md.
# READ-ONLY: uses `defaults read` / `osascript` only. It never writes settings.
# Safe to re-run: overwrites previous exports (idempotent).
set -euo pipefail

REPO="$HOME/Development/refineo/code/refineo-laptop-config"
OUT="$REPO/exports/macos-settings"
mkdir -p "$OUT"

# Read a single defaults domain into a file; never fail the whole run if a
# domain doesn't exist on this machine.
dump_domain() {
  local domain="$1" file="$2"
  echo "==> $domain -> $file"
  defaults read "$domain" > "$OUT/$file" 2>/dev/null \
    || echo "    (no settings for $domain — skipped)" > "$OUT/$file"
}

echo "==> Catch-all snapshots (grep these for anything not called out below)"
defaults domains | tr ',' '\n' | sed 's/^ *//' > "$OUT/defaults-domains.txt"
defaults read > "$OUT/all-defaults.txt" 2>/dev/null || true

echo "==> Text replacements"
defaults read NSGlobalDomain NSUserDictionaryReplacementItems \
  > "$OUT/text-replacements.txt" 2>/dev/null \
  || echo "(none — or synced via iCloud)" > "$OUT/text-replacements.txt"

dump_domain "NSGlobalDomain"                                   "globaldomain.txt"
dump_domain "com.apple.finder"                                 "finder.txt"
dump_domain "com.apple.dock"                                   "dock.txt"
dump_domain "com.apple.symbolichotkeys"                        "symbolichotkeys.txt"
dump_domain "com.apple.screencapture"                          "screencapture.txt"
dump_domain "com.apple.AppleMultitouchTrackpad"               "trackpad-builtin.txt"
dump_domain "com.apple.driver.AppleBluetoothMultitouch.trackpad" "trackpad.txt"
dump_domain "com.apple.HIToolbox"                              "hitoolbox.txt"
dump_domain "com.apple.Spotlight"                              "spotlight.txt"
dump_domain "com.apple.systemuiserver"                         "menubar-extras.txt"

echo "==> Login items (via System Events)"
osascript -e 'tell application "System Events" to get the name of every login item' \
  > "$OUT/login-items.txt" 2>/dev/null \
  || echo "(could not read login items — check System Settings manually)" > "$OUT/login-items.txt"

echo "==> Default browser / terminal (not cleanly readable — note for manual check)"
cat > "$OUT/manual-check.txt" <<'NOTE'
These are not reliably readable via `defaults` — confirm on the OLD machine and
re-set on the NEW one:
  [ ] Default web browser  (System Settings > Desktop & Dock > Default web browser)
  [ ] Terminal you use     (goal: iTerm2 — quit Terminal.app, pin iTerm2)
  [ ] Night Shift schedule (System Settings > Displays > Night Shift)
  [ ] Menu-bar item order  (Sonoma+ stores much of this outside defaults)
NOTE

echo "==> Reminders that CANNOT be scripted (do these in-app):"
cat <<'REMIND'
  [ ] iTerm2   : Settings > General > Preferences > Save to folder -> exports/iterm2/
  [ ] Raycast  : Settings > Advanced > Export Settings & Data
  [ ] Review docs/macos-settings.md — it is the re-apply guide for everything above
REMIND

echo "==> Done. Review $OUT, then: git add -A && git commit && git push"
