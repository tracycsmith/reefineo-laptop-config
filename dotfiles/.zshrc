# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
export PERSONAL_OBSIDIAN_DIR="$HOME/Documents/Obsidian/Personal"

# ---------------------------------------------------------
# Base directories
# ---------------------------------------------------------
export PERSONAL_DEV_DIR="$HOME/Development"
export NVM_DIR="$HOME/.nvm"

# ---------------------------------------------------------
# Project directories for shell + Claude skills
# ---------------------------------------------------------
export PROJECT_CB="$PERSONAL_DEV_DIR/cb/code"
export PROJECT_LWD="$PERSONAL_DEV_DIR/lwd/code/leading-while-distracted"
export PROJECT_MHC="$PERSONAL_DEV_DIR/mhc/code/mhc-control-panel-legacy"
export PROJECT_HCS="$PERSONAL_DEV_DIR/mhc/code/hudson-cage"
export PROJECT_PDM="$PERSONAL_DEV_DIR/refineo/code/personal-dam"
export PROJECT_REF="$PERSONAL_DEV_DIR/refineo/code/refineo-studios-site"
export PROJECT_CLAUDE_BASELINE="$PERSONAL_DEV_DIR/shared/code/claude-baseline"

# Backward compatibility with your existing variable
export CLAUDE_BASELINE_DIR="$PROJECT_CLAUDE_BASELINE"

source $(brew --prefix nvm)/nvm.sh

# cbplay() — removed 2026-07-09; needed iina + yt-dlp (dropped). Restore both via brew if needed.
# cbplay() {
#   iina "$(yt-dlp -g https://chaturbate.com/$1/)"
# }

function iterm2_print_user_vars() {
  local repo=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$repo" ]]; then
    iterm2_set_user_var gitProject "$(basename "$repo")"
  else
    iterm2_set_user_var gitProject ""
  fi
}
precmd_functions+=(iterm2_print_user_vars)

_git_branch() {
  command git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/ (/; s/$/)/'
}

PROMPT='%(
%{$fg_bold[green]%}➜
%{$fg_bold[red]%}➜
) %{$fg_bold[cyan]%}%~%{$fg_bold[green]%}$(_git_branch)%{$reset_color%} -> '
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

autoload -Uz compinit
compinit

source "$HOME/.zsh.d/aliases.mine.zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="$HOME/.local/bin:$PATH"
eval "$(direnv hook zsh)"
cd "$PERSONAL_DEV_DIR"
clear
ls -all

# ── dev shortcuts (added 2026-04-19) ──────────────────────────────────────────
# Start each project's dev stack (api + worker + web in parallel).
# Foreground — Ctrl-C stops everything. Close the terminal window = same thing.
alias dev-mhc='cd $HOME/Development/mhc/code/mhc-cp && pnpm --parallel -r dev'
alias dev-dam='cd $HOME/Development/refineo/code/personal-dam && pnpm dev'
# Kill all pnpm dev processes across both projects (use if Ctrl-C missed one).
alias dev-stop='pkill -f "pnpm.*dev" || echo "nothing running"'
# Show what's listening on the dev ports.
alias dev-ps='lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | grep -E ":(3000|3001|5173|5174)"'

# ── joyCaption (added 2026-06-27) ─────────────────────────────────────────────
# Start the JoyCaption Gradio UI at http://127.0.0.1:7860 (bf16 on Apple MPS).
# Foreground — Ctrl-C stops it and frees the ~17GB. Subshell keeps your cwd unchanged.
alias joycaption='(cd $HOME/Development/mhc/code/joycaption/gradio-app && PYTORCH_ENABLE_MPS_FALLBACK=1 .venv/bin/python app.py)'
# Stop a JoyCaption server and reclaim its memory (use if it is running in the background).
alias joycaption-stop='pkill -f "gradio-app/app.py" && echo "stopped" || echo "nothing running"'
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/tracysmith/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
