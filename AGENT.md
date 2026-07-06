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

## Conventions

- Brewfile is the single source of truth for installed software
- Nothing sensitive in this repo — secrets are inventoried by LOCATION only, values in 1Password
- Every service must have an entry in docs/services-and-ports.md
- exports/ holds machine-generated state (brew dump, pg dump, pm2) — regenerate via scripts/00
- Scripts are idempotent zsh, numbered in run order

## Open decisions

- Docker engine: plan assumes OrbStack only (docker-desktop commented out in Brewfile)
- Node: plan installs latest LTS only (old machine had 5 versions)
- Cask names to verify: cleanmymac, commander-one, plottr
