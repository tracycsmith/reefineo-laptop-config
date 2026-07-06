# refineo-laptop-config

Reproducible macOS setup for Tracy Smith's laptops. Audit → plan → scripts → done.

## Quick start (new machine)

1. Read `docs/00-pre-plan.md` (old machine) → `docs/01-the-plan.md` (new machine)
2. Scripts run in numeric order: `scripts/00` on the OLD machine, `01`–`06` on the NEW one
3. `Brewfile` = source of truth for all software
4. `docs/services-and-ports.md` = how every service starts and where it listens

## Layout

    Brewfile                 all software (brew + cask + mas)
    vscode-extensions.txt    VS Code extension list
    scripts/                 numbered, idempotent setup scripts
    dotfiles/                zsh, git, ssh config (no secrets)
    launchagents/            custom launchd plists
    refineo-scripts/         personal automation (apple-card-filer)
    exports/                 machine-generated state (git-ignored where large)
    docs/                    pre-plan, plan, post-plan, audit, service map

Secrets are never stored here. Locations are inventoried in the audit doc; values live in 1Password.
