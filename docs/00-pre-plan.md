# Pre-Plan — Before the New Laptop (run on OLD machine)

Target: complete by Thursday night. New laptop arrives Friday.

## Exports (scripted)

- [ ] Run `scripts/00-preflight-old-laptop.sh` — dumps brew state, VS Code extensions, npm globals, Postgres (`pg_dumpall`), pm2 config into `exports/`
- [ ] Commit + push this repo after the script runs

## Exports (manual, in-app)

- [ ] Run `scripts/00b-capture-settings.sh` — snapshots macOS prefs into `exports/macos-settings/` (see `docs/macos-settings.md`)
- [ ] Keyboard Maestro: File > Export Macros → `exports/keyboard-maestro/`
- [ ] OBS: export Scene Collection + Profile → `exports/obs/`
- [ ] Stream Deck: Preferences > Profiles > Backup All → `exports/streamdeck/`
- [ ] Raycast: Settings > Advanced > Export Settings & Data
- [ ] iTerm2: Settings > General > Preferences > save to folder → `exports/iterm2/`
- [ ] TablePlus: export connections
- [ ] Obsidian: confirm vault sync/backup current (`~/Documents/Obsidian/Personal`)

## Secrets inventory — verify each is reachable WITHOUT this laptop

Transfer method: manual (1Password / AirDrop). Nothing sensitive goes in this repo.

- [ ] SSH keys — live in 1Password (agent config only on disk). Verify each key exists in 1Password
- [ ] `~/.aws/credentials` + `~/.aws/config` — copy values into 1Password
- [ ] `.env` files (5 projects — list in `scripts/05-repos.sh`) — store each in 1Password as secure notes
- [ ] `gh` auth — will re-auth via browser, nothing to export
- [ ] `~/.config/op`, `~/.render`, `~/.supabase`, `~/.sfdx` — CLI logins; will re-auth on new machine
- [ ] Locate license keys and store each in 1Password:
  - [ ] Keyboard Maestro
  - [ ] CleanMyMac
  - [ ] Commander One
  - [ ] Scrivener
  - [ ] Plottr
  - [ ] Under My Roof

## Data staging (external drive / network — NOT Migration Assistant)

Full manifest + rsync templates in `docs/data-transfer.md`.

- [ ] Run the pre-flight sweep (uncommitted work in `~/Development`, loose Desktop/Downloads)
- [ ] Stage user data to the external drive (or confirm the network path works): `~/Documents`
      (incl. Obsidian vault), `~/Downloads/Personal`, `~/Desktop`, Photos (or confirm iCloud)
- [ ] Confirm `exports/` (brew/pg/pm2/macos-settings/iTerm2/Raycast) is committed or copied

## Housekeeping / decisions

- [ ] DECISION: Keyboard Maestro — review every macro group and note what each does + whether still used (expect dead Stream Deck macros; Stream Deck isn't connected anymore). **Capture the screensnap macro's trigger + action** so it can be rebuilt in Raycast or Shortcuts.app if KM is dropped. Export macros regardless, then set KM's row in `docs/software-inventory.md`
- [x] DECISION: Docker — **OrbStack only**. Dropped both `brew "docker"` and `cask "docker-desktop"` from the Brewfile (OrbStack ships the docker CLI + engine)
- [ ] DECISION: which node versions to carry (old machine had v24.14/24.15/25.8.x/25.9; plan installs latest LTS only)
- [ ] Evernote is a login item but the app is gone — dead entry, do not migrate
- [ ] Stray file `10941866_...jpg` sitting in /Applications — junk, delete
- [ ] `postgresql@16` data dir still exists at /opt/homebrew/var — confirm nothing needed, do not migrate
- [ ] `unbound` shows in brew services but not in leaves — dependency; not migrated deliberately
- [ ] Verify iCloud, 1Password, Obsidian, Notion, Linear, Slack all fully synced
