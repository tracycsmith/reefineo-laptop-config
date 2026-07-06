# Services & Ports — The "How Does This Run Again?" Doc

Rule: nothing runs on this machine without an entry here.

## Databases

| Service | How installed | Start | Port | Notes |
|---|---|---|---|---|
| PostgreSQL 18 | brew `postgresql@18` | `brew services start postgresql@18` | 5432 | brew-services managed; data in /opt/homebrew/var/postgresql@18 |
| Project DBs | Docker (compose per repo) | `docker compose up -d` in repo | per compose file | mhc-cp, personal-dam, media-vault-ops, refineo-studios-site each have docker-compose.yml |

## Dev apps (pm2-managed)

Config: `~/.config/pm2/ecosystem.config.cjs` (copy in repo `exports/pm2/`)

| App | Working dir | Command | Ports |
|---|---|---|---|
| mhc-dev | ~/Development/mhc/code/mhc-cp | `pnpm --parallel -r dev` | 3000 / 3001 |
| personal-dam-dev | ~/Development/refineo/code/personal-dam | `pnpm dev` | 5173 / 5174 |

Daily: `pm2 status`, `pm2 logs mhc-dev`, `pm2 restart <name>`
Shell shortcuts: `dev-mhc`, `dev-dam`, `dev-stop`, `dev-ps` (defined in .zshrc)

## Other services

| Service | Start | Port | Notes |
|---|---|---|---|
| JoyCaption (Gradio) | `joycaption` alias | 7860 | ~17GB RAM on MPS; `joycaption-stop` to free |
| apple-card-filer | launchd (auto) | n/a | Watches ~/Downloads/Personal; logs ~/Library/Logs/apple-card-filer.* |
| Docker engine | OrbStack app | n/a | context `orbstack`; Docker Desktop NOT migrated |

## Ports that are NOT yours

5000 / 7000 = macOS AirPlay Receiver (ControlCenter). Don't fight it; disable in
System Settings > General > AirDrop & Handoff if a dev tool needs 5000.

## launchd inventory (migrated items only)

- `com.refineo.apple-card-filer` — user LaunchAgent, source in repo `launchagents/`
- Everything else (Elgato, Google updaters, CleanMyMac) self-installs with its app
