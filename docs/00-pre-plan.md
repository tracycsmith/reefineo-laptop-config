# Pre-Plan — Before the New Laptop (run on OLD machine)

Target: complete by Thursday night. New laptop arrives Friday.

## Exports (scripted)

- [ ] Run `scripts/00-preflight-old-laptop.sh` — dumps brew state, VS Code extensions, npm globals, Postgres (`pg_dumpall`), pm2 config into `exports/`
- [ ] Commit + push this repo after the script runs

## Exports (manual, in-app)

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
- [ ] Keyboard Maestro, CleanMyMac, Commander One, Scrivener, Plottr, Under My Roof — locate license keys, store in 1Password

## Housekeeping / decisions

- [ ] DECISION: Docker Desktop vs OrbStack — active context was OrbStack; pm2 comment says Docker Desktop runs the DBs. Pick ONE for the new machine (plan assumes OrbStack)
- [ ] DECISION: which node versions to carry (old machine had v24.14/24.15/25.8.x/25.9; plan installs latest LTS only)
- [ ] Evernote is a login item but the app is gone — dead entry, do not migrate
- [ ] Stray file `10941866_...jpg` sitting in /Applications — junk, delete
- [ ] `postgresql@16` data dir still exists at /opt/homebrew/var — confirm nothing needed, do not migrate
- [ ] `unbound` shows in brew services but not in leaves — dependency; not migrated deliberately
- [ ] Verify iCloud, 1Password, Obsidian, Notion, Linear, Slack all fully synced
