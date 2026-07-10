#!/bin/zsh
# scripts/06-services.sh
# @file 06-services.sh
# @description Databases, restores, and launch agents. Run AFTER repos + .env files.
set -euo pipefail

# Explicit PATH — do not rely on inherited environment (fix 2026-07-10)
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

REPO="$HOME/Development/refineo/code/refineo-laptop-config"

echo "==> Postgres 18"
brew services start postgresql@18
sleep 3
DUMP=$(ls -t "$REPO"/exports/postgres-dumpall-*.sql 2>/dev/null | head -1 || true)
if [ -n "$DUMP" ]; then
  echo "    restoring $DUMP"
  psql -d postgres -f "$DUMP" && echo "    restore OK"
else
  echo "    no dump found in exports/ — skipping restore"
fi

echo "==> apple-card-filer launch agent"
mkdir -p "$HOME/Library/Application Support/Refineo/Scripts" "$HOME/Downloads/Personal"
cp "$REPO/refineo-scripts/apple-card-statement-filer.py" "$HOME/Library/Application Support/Refineo/Scripts/"
# Rewrite home path for this machine (launchd cannot expand $HOME)
sed "s|/Users/tracysmith|$HOME|g" "$REPO/launchagents/com.refineo.apple-card-filer.plist" > "$HOME/Library/LaunchAgents/com.refineo.apple-card-filer.plist"
launchctl unload "$HOME/Library/LaunchAgents/com.refineo.apple-card-filer.plist" 2>/dev/null || true
launchctl load "$HOME/Library/LaunchAgents/com.refineo.apple-card-filer.plist"
echo "    watching ~/Downloads/Personal; logs: ~/Library/Logs/apple-card-filer.*.log"

echo "==> Docker databases (per project, from repo compose files)"
echo "    cd ~/Development/mhc/code/mhc-cp && docker compose up -d"
echo "    cd ~/Development/refineo/code/personal-dam && docker compose up -d"

echo "==> pm2 autostart (only after apps verified working manually)"
echo "    pm2 start ~/.config/pm2/ecosystem.config.cjs && pm2 save && pm2 startup"
echo "==> Done. Work through docs/02-post-plan.md"
