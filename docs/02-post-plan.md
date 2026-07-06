# Post-Plan — After the New Laptop Works

## Week 1 shakedown

- [ ] Keep old laptop powered off but nearby for 5–7 days as a safety net
- [ ] Anything missing? Add it to the Brewfile/scripts FIRST, then install — keep the repo the source of truth
- [ ] Verify a full week of workflows: Phase2 work day, MHC dev, personal-dam dev, one stream, one Substack post
- [ ] Confirm apple-card-filer fires when a statement lands in ~/Downloads/Personal
- [ ] Confirm Time Machine/backup has run at least twice

## Old laptop — wipe and sell

Only after everything above is checked.

1. Final sweep: `ls ~/Desktop ~/Downloads ~/Documents` for strays; check `~/Development` for uncommitted work: `find ~/Development -name "*.git" -maxdepth 4 -execdir git status -s \;`
2. Sign out / deauthorize (in order):
   - [ ] Music/TV: Account > Authorizations > Deauthorize This Computer
   - [ ] TurboTax: deactivate license if applicable
   - [ ] Keyboard Maestro, CleanMyMac, Commander One, Scrivener, Plottr: deactivate license seats
   - [ ] 1Password: remove this device (from ANOTHER device, after wipe)
   - [ ] GitHub: Settings > Sessions — revoke old laptop; delete its SSH signing key entry if machine-specific
   - [ ] Sign out iCloud (System Settings > Apple ID > Sign Out) — removes Find My lock
3. Unpair Bluetooth devices
4. System Settings > General > Transfer or Reset > **Erase All Content and Settings**
   (Apple Silicon: this cryptographically wipes — no multi-pass needed)
5. Confirm device no longer appears in Find My + Apple ID device list
6. Fresh macOS boots to Setup Assistant → ready to sell
7. Sale prep: photos, original box/charger, check serial for AppleCare transfer

## Future maintenance (self-documenting loop)

- Quarterly: run `scripts/00-preflight-old-laptop.sh` to refresh exports; commit
- Any new service: document its port + start command in docs/services-and-ports.md BEFORE first use
- Any new app: add to Brewfile first, install via `brew bundle`
