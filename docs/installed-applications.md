# Installed Applications — Cross-Check (old laptop, snapshot 2026-07-06)

Every GUI app actually present in `/Applications` (+ `~/Applications`), with its **live**
version and the decision it currently carries in `docs/software-inventory.md`. Use this to
double-check the Keep / Removed / Undecided calls against reality, then we reconcile any
differences.

- **Versions here are the true on-disk versions** (read from each app's `Info.plist`). Many
  are newer than the version brew has recorded, because these apps self-update outside brew
  (e.g. OrbStack, VS Code, Raycast, Chrome). That drift is expected — brew installs latest on
  the new machine anyway.
- CLI-only tools (git, jq, ripgrep, …) don't live in `/Applications` — they're tracked
  separately in the inventory.
- Status legend: **Keep / Removed / Undecided** = from the inventory · **System** = built-in
  macOS · **Component** = bundled helper of a tracked app (no separate decision).

## `/Applications`

| Application | Version | Status | Notes |
| --- | --- | --- | --- |
| 1Password | 8.12.26 | Keep | |
| 1Password for Safari | 8.12.26 | Component | ships with 1Password |
| AnyList | 1.2 | Keep | |
| Claude | 1.18286.0 | Keep | |
| CleanMyMac_5 | 5.5.0 | Undecided | verify cask name; still needed? |
| Commander One PRO | 3.17.2 | Undecided | verify cask name |
| CopyClip 2 | 3.993 | Undecided | ⚠ installed app is **CopyClip 2** v3.993 — cask `copyclip` is v2.9.99.51. Confirm which you use (App Store vs brew) |
| Elgato Camera Hub | 2.2.1 | Undecided | streaming |
| Elgato Control Center | 1.8.2 | Undecided | streaming |
| Elgato Stream Deck | 7.4.2 | Undecided | Stream Deck not currently connected |
| GarageBand | 10.4.14 | Undecided | large; keep if used |
| Google Chrome | 150.0.7871.47 | Keep | |
| IINA | 1.4.3 | Keep | |
| Keyboard Maestro | 11.0.4 | Undecided | macro review pending |
| Keynote | 14.5 | Keep | mas |
| Linear | 1.30.0 | Keep | |
| Notion | 7.7.1 | Keep | |
| Numbers | 14.5 | Keep | mas |
| OBS | 32.1.1 | Undecided | streaming |
| Obsidian | 1.11.7 | Keep | |
| OrbStack | 2.2.1 | Keep | docker engine |
| Pages | 14.5 | Keep | mas |
| Plottr | 2025.12.4 | Keep | manual download |
| Postman | 11.84.2 | Undecided | confirm still used |
| Raycast | 1.104.21 | Keep | |
| Remote Desktop | 3.10 | Keep | mas: Apple Remote Desktop |
| Safari | 26.5 | System | built-in |
| Scrivener | 3.5.2 | Keep | verify cask name |
| Slack | 4.49.81 | Keep | |
| Telegram | 12.7 | Keep | |
| TurboTax 2025 | 2025.r27.046 | Keep | mas, manual, annual |
| Under My Roof | 1.13 | Keep | mas, manual |
| Visual Studio Code | 1.125.1 | Keep | |
| WhatsApp | 26.18.72 | Keep | |
| iMovie | 10.4.4 | Undecided | large; keep if used |
| iTerm | 3.6.11 | Keep | cask `iterm2` |
| iTermBrowserPlugin | 1.0 | Component | ships with iTerm2 |

## `~/Applications`

| Application | Version | Status | Notes |
| --- | --- | --- | --- |
| Claude Code URL Handler | — | Component | auto-created by Claude Code CLI |

## Reconciliation — differences to resolve

1. **docker-desktop** — brew still records the `docker-desktop` cask as installed, but there
   is **no Docker app** in `/Applications`. It's effectively already gone, which matches the
   **Removed** decision. Optional tidy on the old machine: `brew uninstall --cask docker-desktop`.
2. **CopyClip** — the running app is **CopyClip 2 (v3.993)**; the tracked cask is `copyclip`
   (v2.9.99.51). These look like different distributions (App Store vs brew). Confirm which one
   you actually use before deciding — if it's the App Store version, the brew cask is the wrong
   thing to carry over.
3. **Version drift (informational)** — nearly every self-updating app is newer on disk than
   brew's recorded version (OrbStack 2.2.1 vs 2.0.5, VS Code 1.125.1 vs 1.109.3, Raycast, Chrome,
   Notion, Telegram, Slack, WhatsApp, Claude). No action — brew installs latest on the new
   machine. Noted so the numbers don't look inconsistent between docs.
4. **Not tracked (no decision needed)** — Safari (system), 1Password for Safari, iTermBrowserPlugin,
   and Claude Code URL Handler are all system/bundled components.
5. **Everything in the inventory is accounted for** — every cask/mas app in
   `software-inventory.md` maps to an app above (or is a CLI tool tracked separately). No inventory
   item is missing from disk except docker-desktop (see #1).
