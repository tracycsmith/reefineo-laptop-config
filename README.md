# refineo-laptop-config

Reproducible macOS setup for Tracy Smith's laptops. Audit → plan → scripts → done.

## Quick start (new machine)

1. **Before Friday (old machine):** work `docs/00-pre-plan.md` — run `scripts/00` and
   `scripts/00b`, review `docs/software-inventory.md` (prune cruft), stage data per
   `docs/data-transfer.md`
2. **Friday (new machine):** follow `docs/01-the-plan.md` phases; scripts `01`–`06` run in order
3. `Brewfile` = source of truth for all software (edit it for anything you Drop in the inventory)
4. `docs/macos-settings.md` = re-apply system prefs deliberately; `docs/services-and-ports.md`
   = how every service starts and where it listens

## Layout

    Brewfile                 all software (brew + cask + mas)
    vscode-extensions.txt    VS Code extension list
    scripts/                 numbered, idempotent setup scripts (incl. 00b settings capture)
    dotfiles/                zsh, git, ssh config (no secrets)
    launchagents/            custom launchd plists
    refineo-scripts/         personal automation (apple-card-filer)
    exports/                 machine-generated state (git-ignored where large)
    docs/                    pre-plan, plan, post-plan, audit, service map,
                             software-inventory, installed-applications,
                             macos-settings, data-transfer

Secrets are never stored here. Locations are inventoried in the audit doc; values live in 1Password.
