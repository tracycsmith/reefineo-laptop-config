#!/bin/zsh
# scripts/00-preflight-old-laptop.sh
# @file 00-preflight-old-laptop.sh
# @description Run ON THE OLD LAPTOP before switching. Exports live state
#              (brew, extensions, databases) into this repo so nothing is lost.
# Safe to re-run: overwrites previous exports (idempotent).
set -euo pipefail

REPO="$HOME/Development/refineo/code/refineo-laptop-config"
EXPORTS="$REPO/exports"
mkdir -p "$EXPORTS"

echo "==> Dumping current brew state (full, including deps)"
brew bundle dump --force --file="$EXPORTS/Brewfile.full-dump"

echo "==> Exporting VS Code extensions"
code --list-extensions > "$REPO/vscode-extensions.txt"

echo "==> Exporting npm globals"
npm ls -g --depth=0 > "$EXPORTS/npm-globals.txt" 2>/dev/null || true

echo "==> Dumping Postgres (starts service if needed)"
brew services start postgresql@18 && sleep 3
pg_dumpall > "$EXPORTS/postgres-dumpall-$(date +%Y%m%d).sql" \
  && echo "    dump OK: $(du -h "$EXPORTS"/postgres-dumpall-*.sql | tail -1)" \
  || echo "    WARNING: pg_dumpall failed — check postgres manually"

echo "==> Exporting pm2 ecosystem + process list"
mkdir -p "$EXPORTS/pm2"
cp ~/.config/pm2/ecosystem.config.cjs "$EXPORTS/pm2/" 2>/dev/null || true
pm2 jlist > "$EXPORTS/pm2/pm2-processes.json" 2>/dev/null || true

echo "==> Reminders that CANNOT be scripted (do these in-app):"
cat <<'REMIND'
  [ ] Keyboard Maestro : File > Export Macros  -> exports/keyboard-maestro/
  [ ] OBS              : Scene Collection > Export + Profile > Export
  [ ] Stream Deck      : Preferences > Profiles > gear > Backup All
  [ ] Raycast          : Settings > Advanced > Export Settings & Data
  [ ] iTerm2           : Settings > General > Preferences > Save to folder
  [ ] TablePlus        : export connections (Connections > Export)
  [ ] Postman          : sign-in syncs; verify workspace is cloud-synced
REMIND

echo "==> Done. Review exports/, then: git add -A && git commit && git push"
