# =========================================================
# Project navigation
# Uses exported project variables from ~/.zshrc
# =========================================================

# clear any existing aliases that would conflict
unalias cb 2>/dev/null
unalias lwd 2>/dev/null
unalias mhc 2>/dev/null
unalias hcs 2>/dev/null
unalias pdm 2>/dev/null
unalias ref 2>/dev/null
unalias nav 2>/dev/null
unalias dev 2>/dev/null

# ---------- help ----------
navhelp() {
  cat <<EOF
Project shortcuts

  cb    cb, default dir: cb/code
  lwd   lwd, default dir: lwd/code/leading-while-distracted
  mhc   mhc, default dir: mhc/code/mhc-control-panel
  hcs   mhc, default dir: mhc/code/hudson-cage
  pdm   refineo, default dir: refineo/code/personal-dam
  ref   refineo, default dir: refineo/code/refineo-studios-site

Claude-friendly exported vars

  \$PROJECT_CB
  \$PROJECT_LWD
  \$PROJECT_MHC
  \$PROJECT_HCS
  \$PROJECT_PDM
  \$PROJECT_REF
  \$PROJECT_CLAUDE_BASELINE

Usage

  <alias>
      Go to that alias's default directory

  <alias> root
      Go to the project root

  <alias> docs
      Go to the docs directory

  <alias> assets
      Go to the assets directory

  <alias> code
      Go to the code directory

  <alias> code <subdir>
      Go to a subdirectory inside code

Examples

  cb
  cb docs
  cb code cb-affiliate-api-script

  lwd
  lwd root
  lwd assets
  lwd code
  lwd code leading-while-distracted

  mhc
  mhc docs
  mhc code
  mhc code mhc-control-panel-extension

  hcs
  hcs root
  hcs code hudson-cage

  pdm
  pdm code personal-dam

  ref
  ref docs
  ref code refineo-studios-site

Valid first parameters

  root
  docs
  assets
  code

Tip

  Type an alias, then press Tab to see valid options.
  Example:
    mhc <TAB>
    mhc code <TAB>

EOF
}

function nav { navhelp; }

function dev {
  cd "$PERSONAL_DEV_DIR" || return
  clear
  ls -all
  pwd -P
}

# ---------- core engine ----------
_nav_project() {
  local brand="$1"
  local default_path="$2"
  local section="${3:-}"
  local extra="${4:-}"
  local target=""

  case "$section" in
    "" )
      target="$default_path"
      ;;
    root )
      target="$PERSONAL_DEV_DIR/$brand"
      ;;
    docs )
      target="$PERSONAL_DEV_DIR/$brand/docs"
      ;;
    assets )
      target="$PERSONAL_DEV_DIR/$brand/assets"
      ;;
    code )
      if [[ -n "$extra" ]]; then
        target="$PERSONAL_DEV_DIR/$brand/code/$extra"
      else
        target="$PERSONAL_DEV_DIR/$brand/code"
      fi
      ;;
    * )
      echo "Invalid option: $section"
      echo "Use: root, docs, assets, code"
      echo "Run 'nav' for help."
      return 1
      ;;
  esac

  if [[ -d "$target" ]]; then
    cd "$target" || return
    clear
    ls -all
    pwd -P
  else
    echo "Directory does not exist:"
    echo "  $target"
    return 1
  fi
}

# ---------- shortcuts ----------
function cb  { _nav_project "cb"      "$PROJECT_CB"   "$1" "$2"; }
function lwd { _nav_project "lwd"     "$PROJECT_LWD"  "$1" "$2"; }
function mhc { _nav_project "mhc"     "$PROJECT_MHC"  "$1" "$2"; }
function hcs { _nav_project "mhc"     "$PROJECT_HCS"  "$1" "$2"; }
function pdm { _nav_project "refineo" "$PROJECT_PDM"  "$1" "$2"; }
function ref { _nav_project "refineo" "$PROJECT_REF"  "$1" "$2"; }

# ---------- tab completion ----------
_nav_complete() {
  local -a sections
  sections=(root docs assets code)

  local cmd="${words[1]}"
  local code_dir=""

  case "$cmd" in
    cb)
      code_dir="$PERSONAL_DEV_DIR/cb/code"
      ;;
    lwd)
      code_dir="$PERSONAL_DEV_DIR/lwd/code"
      ;;
    mhc|hcs)
      code_dir="$PERSONAL_DEV_DIR/mhc/code"
      ;;
    pdm|ref)
      code_dir="$PERSONAL_DEV_DIR/refineo/code"
      ;;
    *)
      return 1
      ;;
  esac

  if (( CURRENT == 2 )); then
    _describe 'section' sections
    return
  fi

  if (( CURRENT == 3 )) && [[ "${words[2]}" == "code" ]]; then
    local -a subdirs
    subdirs=()

    if [[ -d "$code_dir" ]]; then
      local d
      for d in "$code_dir"/*(/N); do
        subdirs+=("${d:t}")
      done
    fi

    _describe 'code directory' subdirs
    return
  fi
}

compdef _nav_complete cb
compdef _nav_complete lwd
compdef _nav_complete mhc
compdef _nav_complete hcs
compdef _nav_complete pdm
compdef _nav_complete ref

alias x='exit'
