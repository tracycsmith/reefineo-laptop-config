# AGENT.md — refineo-laptop-config

Purpose: reproducible laptop setup + self-documenting machine state for Tracy Smith.
If a session dies, this file is the re-entry point.

## State (2026-07-06)

- Full audit of old laptop complete → docs/audit-2026-07-06.md
- Plan docs written: docs/00-pre-plan.md → 01-the-plan.md → 02-post-plan.md
- Scripts 00–06 written (preflight → bootstrap → apps → shell → dev → repos → services)
- Brewfile generated (leaves + casks + formerly hand-installed apps + mas)
- Dotfiles + launch agent + apple-card-filer script vendored into repo
- Docs mirrored to Obsidian: ~/Documents/Obsidian/Personal/40 Refineo Studios/Laptop Migration 2026/
- Reworked into a step-by-step guide: CSV lists → bullets; added docs/software-inventory.md
  (Keep/Drop/Decide), docs/macos-settings.md + scripts/00b (read-only prefs capture),
  docs/data-transfer.md (external-drive/network — NOT Migration Assistant)
- Fixed repo-slug typo reefineo→refineo in scripts 01 + 05

## Conventions

- Brewfile is the single source of truth for installed software
- Nothing sensitive in this repo — secrets are inventoried by LOCATION only, values in 1Password
- Every service must have an entry in docs/services-and-ports.md
- exports/ holds machine-generated state (brew dump, pg dump, pm2) — regenerate via scripts/00
- Scripts are idempotent zsh, numbered in run order

## Open decisions

- Transfer method: external drive / network via rsync — NOT Migration Assistant (docs/data-transfer.md)
- Keyboard Maestro: PENDING macro review — mainly a screensnap shortcut; old Stream Deck
  macros likely dead (Stream Deck not connected). Decide Keep/Drop after reviewing macros;
  if dropped, rebind screensnap in Raycast or Shortcuts.app. Tracked in software-inventory.md
- Docker: RESOLVED — OrbStack only. Both `brew "docker"` and `cask "docker-desktop"`
  dropped from Brewfile (OrbStack ships the docker CLI + engine)
- Node: plan installs latest LTS only (old machine had 5 versions)
- Cask names to verify: cleanmymac, commander-one, plottr
- Prune candidates from inventory review: docker-desktop (Drop), copyclip/corepack/mint,
  Elgato trio (streaming), GarageBand/iMovie (size)
