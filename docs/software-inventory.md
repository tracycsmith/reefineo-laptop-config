# Software Inventory — Keep / Removed / Undecided

The pruning layer for the migration. Every app, CLI tool, and extension on the old laptop
is listed once, with its current version, so nothing carries over by accident and nothing
gets forgotten. Goal: move deliberately, leave the cruft behind.

## How to use this

- Each row has one `✓` in **Keep**, **Removed**, or **Undecided** — pre-filled with my
  recommendation. Move the `✓` to override.
- **Empty the Undecided column before Friday** — every row must land in Keep or Removed.
- For each **Removed**, delete its line from `Brewfile` (source of truth) and skip it in the
  relevant `scripts/0*.sh`. For **mas**/manual items, just don't install them.
- Versions are the old-machine snapshot (captured 2026-07-06); brew installs latest anyway —
  the version is here to identify exactly what you had.
- Cross-check the GUI apps against what's actually installed in `docs/installed-applications.md`.

---

## CLI formulae (Brewfile `brew "…"`)

| Keep | Removed | Undecided | Formula | Version | Used for |
| :--: | :--: | :--: | --- | --- | --- |
| ✓ |   |   | awscli | 2.33.22 | AWS CLI + aws-api-mcp |
|   |   | ✓ | bcrypt | 1.1 | password hashing — confirm still used |
| ✓ |   |   | direnv | 2.37.1 | per-project env (`.envrc`) |
|   | ✓ |   | docker | 29.2.1 | **OrbStack provides the docker CLI — drop** |
| ✓ |   |   | fzf | 0.67.0 | fuzzy finder |
| ✓ |   |   | gh | 2.95.0 | GitHub CLI + auth/credential helper |
| ✓ |   |   | git | 2.53.0 | version control |
|   |   | ✓ | git-filter-repo | 2.47.0 | history rewriting — keep only if still used |
| ✓ |   |   | jq | 1.8.1 | JSON in shell/scripts |
| ✓ |   |   | libpq | 18.3 | psql client libs |
| ✓ |   |   | mas | (new) | Mac App Store CLI |
|   |   | ✓ | node | 25.8.1 | fallback node — nvm may make redundant |
| ✓ |   |   | nvm | 0.40.4 | node version management |
| ✓ |   |   | pnpm | 10.29.3 | package manager |
| ✓ |   |   | poppler | 26.04.0 | PDF tooling (pdftotext) |
| ✓ |   |   | postgresql@18 | 18.3 | primary local database |
| ✓ |   |   | python@3.12 | 3.12.13 | pinned python |
| ✓ |   |   | render | 2.18.0 | Render CLI |
| ✓ |   |   | ripgrep | 15.1.0 | fast search |
| ✓ |   |   | speedtest-cli | 2.1.3 | network checks |
| ✓ |   |   | supabase | 2.90.0 | Supabase CLI |
| ✓ |   |   | tree | 2.3.1 | directory trees |
| ✓ |   |   | uv | 0.11.7 | python packaging |
| ✓ |   |   | yt-dlp | 2026.2.4 | media download |

## Apps — casks (Brewfile `cask "…"`)

| Keep | Removed | Undecided | Cask | Version | Used for |
| :--: | :--: | :--: | --- | --- | --- |
| ✓ |   |   | 1password | 8.12.2 | password mgr, SSH agent, git signer (install first) |
| ✓ |   |   | 1password-cli | 2.33.1 | `op` CLI / secret retrieval |
| ✓ |   |   | anylist | 1.2 | grocery / lists |
| ✓ |   |   | claude | (manual) | Claude desktop |
|   |   | ✓ | cleanmymac | (manual) | maintenance — verify cask name; still needed? |
|   |   | ✓ | commander-one | (manual) | file manager — verify cask name |
|   |   | ✓ | copyclip | 2.9.99.51 | clipboard history — Raycast has this built in |
|   | ✓ |   | docker-desktop | 4.60.1 | **redundant — OrbStack is the engine** |
|   |   | ✓ | elgato-camera-hub | 2.2.1.6945 | camera control — keep if you still stream |
|   |   | ✓ | elgato-control-center | 1.8.2 | key light — keep if you still stream |
|   |   | ✓ | elgato-stream-deck | 7.2.1.22472 | Stream Deck — **not currently connected** |
| ✓ |   |   | google-chrome | (manual) | browser |
| ✓ |   |   | iina | 1.4.1 | video player |
| ✓ |   |   | iterm2 | 3.6.6 | terminal (set as default — see macos-settings.md) |
|   |   | ✓ | keyboard-maestro | 11.0.4 | macros — **run macro review first (00-pre-plan)** |
| ✓ |   |   | linear-linear | (manual) | issue tracking |
| ✓ |   |   | notion | 7.4.0 | notes / docs |
|   |   | ✓ | obs | 32.0.4 | streaming/recording — keep if you still stream |
| ✓ |   |   | obsidian | 1.11.7 | primary knowledge base |
| ✓ |   |   | orbstack | 2.0.5 | docker/linux engine (chosen) |
| ✓ |   |   | plottr | (manual) | story plotting — no cask, download from getplottr.com |
|   |   | ✓ | postman | 11.84.2 | API testing — confirm still used vs cloud sync |
| ✓ |   |   | raycast | 1.104.6 | launcher (+ clipboard, hotkeys) |
| ✓ |   |   | scrivener | (manual) | long-form writing — verify cask name |
| ✓ |   |   | slack | 4.47.72 | team chat |
| ✓ |   |   | tableplus | 6.8.0 | database GUI |
| ✓ |   |   | telegram | (manual) | messaging |
| ✓ |   |   | visual-studio-code | 1.109.3 | editor |
| ✓ |   |   | whatsapp | (manual) | messaging |

## Mac App Store (Brewfile `mas "…"`)

| Keep | Removed | Undecided | App | Version | Used for |
| :--: | :--: | :--: | --- | --- | --- |
| ✓ |   |   | Keynote | — | presentations |
| ✓ |   |   | Pages | — | documents |
| ✓ |   |   | Numbers | — | spreadsheets |
|   |   | ✓ | GarageBand | — | audio — large; keep if used |
|   |   | ✓ | iMovie | — | video — large; keep if used |
| ✓ |   |   | Apple Remote Desktop | — | remote admin |
| ✓ |   |   | TurboTax 2025 | — | taxes — manual install, annual |
| ✓ |   |   | Under My Roof | — | home inventory — manual install |

## npm globals

| Keep | Removed | Undecided | Package | Version | Used for |
| :--: | :--: | :--: | --- | --- | --- |
| ✓ |   |   | fast-cli | 5.2.0 | speed test |
|   | ✓ |   | corepack | 0.34.6 | yarn/pnpm shim — not needed (pnpm via brew) |
|   |   | ✓ | mint | 4.2.434 | Swift CLI-tool manager — confirm use |
| ✓ |   |   | npm | 11.11.0 | bundled with node |

> `pm2` (dev process manager for mhc-dev / personal-dam-dev) is installed by
> `scripts/04-dev.sh`, not a current global — kept by default.

## VS Code extensions

- Full list: `vscode-extensions.txt` (~109 IDs, installed by `scripts/04-dev.sh`).
- The large **Salesforce block** exists only for Phase2 work. If you are leaving Phase2
  tooling behind, trim those IDs from `vscode-extensions.txt` before running `04-dev.sh`.
- Decision (you): ☐ Keep as-is   ☐ Trim Phase2/Salesforce block

## Not migrating (confirmed cruft — no decision needed)

| Item | Why |
| --- | --- |
| Evernote (login item) | App already removed — dead login entry, do not recreate |
| postgresql@16 data dir | Old data at `/opt/homebrew/var`; confirm nothing needed, don't migrate |
| unbound (brew service) | Dependency only, not a leaf — not migrated deliberately |
| stray `.jpg` in /Applications | Junk — delete on old machine |

---

**After you finish:** update `Brewfile` for every `Removed`, then note the outcome in
`AGENT.md` open decisions so the next session knows what was pruned and why.
