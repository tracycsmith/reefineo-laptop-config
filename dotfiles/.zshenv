# ~/.zshenv — sourced by ALL zsh instances (interactive, non-interactive, scripts)
# Keep this lean. Heavy config (aliases, plugins, etc.) belongs in .zshrc.

# Homebrew (Apple Silicon path — must come before /usr/local/bin for arm64)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# NVM — lazy-load so non-interactive shells don't pay the startup cost
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh" --no-use

# Activate default node version for non-interactive shells
[ -s "$NVM_DIR/alias/default" ] && export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin:$PATH"
