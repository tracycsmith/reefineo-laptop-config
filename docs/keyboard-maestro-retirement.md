# Keyboard Maestro — retired 2026-07-10

Decision: NOT installed on new Mac. Full macro audit of old Mac showed only
two custom macros; both replaced natively.

## What KM actually did

| Macro | Hotkey | What it did | Replacement |
|---|---|---|---|
| cb-screenshot-to-mhc | Cmd-/ | Ran Apple Shortcut "cb-cam4-post" | Shortcuts.app > cb-cam4-post > Details > Add Keyboard Shortcut (Cmd-/). Shortcut itself syncs via iCloud |
| Obsidian Markdown | Cmd-Shift-L | Inserted "- [ ] " | Obsidian native checkbox toggle; or Raycast snippet + hotkey for system-wide |

Everything else in the KM library = factory defaults (clipboard filters,
app/clipboard switchers). Nothing custom, nothing migrated.

Related Shortcuts that must exist on the new Mac (iCloud-synced):
- cb-cam4-post  (the Cmd-/ target)
- Grab CB Poster Screenshot

If Shortcuts didn't sync: export from old Mac via Shortcuts > right-click > share/export before wipe.

License: KM license key can stay archived in 1Password in case of future need.
