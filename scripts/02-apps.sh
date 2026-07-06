#!/bin/zsh
# scripts/02-apps.sh
# @file 02-apps.sh
# @description Installs all software from the Brewfile (formulae, casks, App Store).
#              Sign into the App Store BEFORE running (mas needs it).
set -euo pipefail
REPO="$HOME/Development/refineo/code/refineo-laptop-config"

echo "==> brew bundle (this takes a while)"
brew bundle --file="$REPO/Brewfile" || {
  echo "WARNING: some items failed — re-run after fixing; brew bundle is idempotent"; }

echo "==> Post-install notes:"
cat <<'NOTES'
  - OrbStack: launch once, enable 'Start at login'
  - 1Password: sign in FIRST — it is the SSH agent + git signing for everything else
  - Manual App Store installs: TurboTax, Under My Roof
NOTES
echo "==> Next: scripts/03-shell.sh"
