# The Plan — New Laptop Order of Operations (Friday)

Each phase ends with a checkpoint. Small wins, frequent commits.

## Phase 1 — Identity (15 min)

1. macOS setup assistant: sign into iCloud, enable FileVault, set hostname
2. App Store: sign in (needed before mas)
3. Install 1Password FIRST (App Store or download) and sign in
   — it is the SSH agent and git signer; everything downstream depends on it
4. Safari → download nothing else by hand. Everything else is scripted.

CHECKPOINT: 1Password unlocked, SSH agent enabled in 1Password settings.

## Phase 2 — Bootstrap (20 min)

5. Terminal: run `scripts/01-bootstrap.sh` (paste from GitHub web if needed)
   — Xcode CLT, Homebrew, gh auth, directory skeleton, clones this repo

CHECKPOINT: `brew --version` works, repo cloned.

## Phase 3 — Software (45–90 min, mostly waiting)

6. `scripts/02-apps.sh` — full Brewfile: CLI tools, casks, App Store apps
7. Manual App Store: TurboTax, Under My Roof

CHECKPOINT: `brew bundle check` passes.

## Phase 4 — Shell + Dev (30 min)

8. `scripts/03-shell.sh` — oh-my-zsh + dotfiles (open new terminal after)
9. `scripts/04-dev.sh` — nvm/node LTS, npm globals, pm2, VS Code extensions
10. Launch VS Code, sign into Settings Sync/GitHub

CHECKPOINT: new terminal shows custom prompt, `nav` help works, `git commit` signs via 1Password.

## Phase 5 — Repos + Secrets (30 min)

11. `scripts/05-repos.sh` — clones all 19 repos into brand structure
12. Restore `.env` files from 1Password (list printed by script)
13. `~/.aws/` credentials from 1Password
14. CLI auths: `op signin`, `render login`, `supabase login`, `sf org login web` (if Phase2 needs it)

CHECKPOINT: `cd $PROJECT_REF && git status` clean; direnv allows `.envrc` in mhc-legacy.

## Phase 6 — Services + Data (30 min)

15. Restore data folders (Documents, Obsidian vault, Downloads/Personal) from backup/iCloud
16. `scripts/06-services.sh` — Postgres 18 + dump restore, apple-card-filer launch agent
17. OrbStack: launch, enable start-at-login; `docker compose up -d` per project
18. Verify: `dev-mhc` starts, `dev-ps` shows ports 3000/3001/5173/5174

CHECKPOINT: apps reachable on their ports (see services-and-ports.md).

## Phase 7 — Apps config (45 min)

19. Import manual exports: Keyboard Maestro macros, OBS scenes, Stream Deck profiles, Raycast, iTerm2 prefs, TablePlus connections
20. Login items: confirm Keyboard Maestro Engine + Raycast (skip Evernote — dead)
21. Licensed apps: enter keys from 1Password (KM, CleanMyMac, Commander One, Scrivener, Plottr)
22. Obsidian: open vault, verify plugins
23. Elgato: Camera Hub + Control Center + Stream Deck hardware test (streaming setup)

CHECKPOINT: one full test stream/recording in OBS; one KM macro fires.

## Phase 8 — Seal it

24. Update this repo: note anything that differed from plan in docs/audit
25. `git add -A && git commit -m "post-install state" && git push`
26. Copy plan docs to Obsidian (already scripted — see repo README)
27. Time Machine or backup tool: first backup of new machine
