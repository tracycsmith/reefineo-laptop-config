#!/bin/zsh
# scripts/01-bootstrap.sh
# @file 01-bootstrap.sh
# @description FIRST script on the NEW laptop. Installs Xcode CLT + Homebrew,
#              then clones this repo. Everything else runs from the repo.
set -euo pipefail

echo "==> Xcode Command Line Tools"
xcode-select -p >/dev/null 2>&1 || xcode-select --install

echo "==> Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> gh (for authenticated clone)"
brew install gh git
gh auth status >/dev/null 2>&1 || gh auth login

echo "==> Directory skeleton"
mkdir -p ~/Development/{cb,lwd,mhc,personal,phase2,refineo,shared}/code
mkdir -p ~/Documents/Obsidian

echo "==> Clone laptop-config repo"
REPO_DIR="$HOME/Development/refineo/code/refineo-laptop-config"
[ -d "$REPO_DIR/.git" ] || gh repo clone tracycsmith/refineo-laptop-config "$REPO_DIR"

echo "==> Next: run $REPO_DIR/scripts/02-apps.sh"
