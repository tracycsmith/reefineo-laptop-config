# macOS Settings Reference — Capture & Re-apply

The "stuff we always forget": text replacements, keyboard shortcuts, Finder/Dock/trackpad
tweaks, the default terminal, `defaults write` CLI changes, license keys. Because you are
**not** using Migration Assistant, none of this comes over automatically — so it gets
captured here and re-applied **deliberately** on the new machine (pick what you want; leave
the cruft behind).

## Workflow

1. **On the OLD machine:** run `scripts/00b-capture-settings.sh` — it dumps everything below
   into `exports/macos-settings/` (read-only, safe, idempotent). Commit the repo after.
2. **On the NEW machine:** work through the sections here. For each, either follow the
   manual steps or paste the `defaults write` snippet, then **log out/in** (or
   `killall Finder Dock SystemUIServer`) for changes to take effect.
3. Only apply what you actually want. This is a menu, not a restore.

> Captured files live in `exports/macos-settings/`. The curated per-domain files
> (`finder.txt`, `globaldomain.txt`, `symbolichotkeys.txt`, …) are committed and travel
> with the repo to the new machine. The catch-all `all-defaults.txt` (full `defaults read`,
> multiple MB, may hold semi-sensitive values) is **git-ignored** — grep it on the OLD
> machine while it still exists for anything not called out below; it does not come along.

---

## 1. Text replacements / substitutions

- **What:** System Settings → Keyboard → Text Replacements (e.g. `omw` → `On my way!`).
- **Captured:** `exports/macos-settings/text-replacements.txt`
  (`defaults read NSGlobalDomain NSUserDictionaryReplacementItems`). These also sync via
  iCloud if "Text Replacements" is enabled in iCloud — verify before assuming they're gone.
- **Re-apply:** if not synced, re-enter under System Settings → Keyboard → Text Replacements,
  or import the plist array. Confirm iCloud sync toggle first (fastest path).

## 2. Keyboard shortcuts (system symbolic hotkeys)

- **What:** custom system key bindings — Spotlight, screenshots, Mission Control, input
  switching, etc. (System Settings → Keyboard → Keyboard Shortcuts).
- **Captured:** `exports/macos-settings/symbolichotkeys.txt`
  (`defaults read com.apple.symbolichotkeys`).
- **Re-apply:** most people only change a few — eyeball the capture for non-defaults and
  re-set them in the UI. The raw plist can be imported but is brittle; manual is safer.
- **Note:** the **screensnap** shortcut currently runs through Keyboard Maestro. If KM is
  dropped (see `software-inventory.md`), rebind it here or via Raycast / Shortcuts.app.

## 3. Finder preferences

- **What:** show path bar / status bar, default new-window folder, show extensions, search
  scope, sort order, show hidden files.
- **Captured:** `exports/macos-settings/finder.txt` (`defaults read com.apple.finder`).
- **Re-apply (common ones):**
  ```sh
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true          # show hidden
  killall Finder
  ```
  Cross-check the captured file for anything else you'd set.

## 4. Dock & menu bar

- **What:** Dock size/position/autohide/magnification, hot corners; menu-bar item layout.
- **Captured:** `exports/macos-settings/dock.txt` (`defaults read com.apple.dock`),
  menu-bar extras in `exports/macos-settings/menubar-extras.txt`.
- **Re-apply (common ones):**
  ```sh
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock tilesize -int 48
  defaults write com.apple.dock orientation -string "bottom"   # left|right|bottom
  defaults write com.apple.dock show-recents -bool false
  # Hot corners: wvous-{tl,tr,bl,br}-corner (2=Mission Control, 4=Desktop, 5=Start Screen Saver, 10=Sleep)
  killall Dock
  ```
- **Menu bar:** item order/visibility is set per-item in System Settings (macOS Sonoma+
  stores much of this outside plain `defaults`) — re-arrange manually using the capture as a
  checklist of what you had.

## 5. Trackpad, input & screenshots

- **What:** tap-to-click, tracking speed, gestures; key-repeat rate; screenshot location/format.
- **Captured:** `exports/macos-settings/trackpad.txt`,
  `exports/macos-settings/screencapture.txt`, plus key-repeat in
  `exports/macos-settings/globaldomain.txt`.
- **Re-apply (common ones):**
  ```sh
  # Tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # Fast key repeat
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  # Screenshots → dedicated folder, no shadow
  mkdir -p ~/Pictures/Screenshots
  defaults write com.apple.screencapture location ~/Pictures/Screenshots
  defaults write com.apple.screencapture disable-shadow -bool true
  killall SystemUIServer
  ```

## 6. Default terminal = iTerm2

- **What:** make iTerm2 the terminal you reach for (macOS has no true "default terminal"
  handler, but you can stop using Terminal.app).
- **Re-apply:**
  - Set iTerm2 → Preferences → General → "iTerm2 as the default terminal" if offered, or
    just quit Terminal.app and pin iTerm2 to the Dock.
  - Make "Open in iTerm2" available in Finder / Services if you use it (iTerm2 install its
    Finder integration on first launch).
  - Import your iTerm2 prefs — see §7.

## 7. iTerm2 configuration

- **Captured:** `exports/iterm2/` (already part of `scripts/00`: iTerm2 → Settings → General →
  Preferences → save to a folder).
- **Re-apply:** iTerm2 → Settings → General → Preferences → "Load preferences from a custom
  folder or URL" → point at `exports/iterm2/`. Restart iTerm2.

## 8. Raycast configuration

- **Captured:** Raycast → Settings → Advanced → Export Settings & Data (part of `scripts/00`).
- **Re-apply:** install Raycast (Brewfile), then Settings → Advanced → Import, select the
  export. Re-check hotkey (default launcher key) and any script commands.
- **Note:** if you drop CopyClip and/or Keyboard Maestro, Raycast can cover clipboard
  history and hotkey-launched actions — reconfigure here.

## 9. Misc power-user settings

- **Spotlight:** indexing categories / order — `exports/macos-settings/spotlight.txt`
  (`com.apple.Spotlight`). Re-set in System Settings → Spotlight.
- **Night Shift / display:** re-set manually (System Settings → Displays → Night Shift).
- **Energy / lock:** screen-off + require-password timing — System Settings → Lock Screen.
- **Default browser:** set Chrome (or Safari) in System Settings → Desktop & Dock →
  Default web browser.
- **Login items:** `exports/macos-settings/login-items.txt`. Re-enable only what you want —
  expected: Raycast (+ Keyboard Maestro Engine only if KM is kept). Skip Evernote (dead).

## 10. License keys

- **Do NOT store values in this repo.** Keys live in 1Password (see `docs/00-pre-plan.md`).
- Apps needing a key re-entered on the new machine: Keyboard Maestro (if kept), CleanMyMac,
  Commander One, Scrivener, Plottr, Under My Roof.

## 11. `defaults write` CLI tweaks — capture table

Any OS behavior you changed from the command line lives in some `defaults` domain. The
capture script snapshots the whole domain space so you can diff against a clean machine.

| Domain | Holds | Captured file |
| --- | --- | --- |
| `NSGlobalDomain` | text replacements, key-repeat, tap-behavior, show-extensions | `globaldomain.txt` |
| `com.apple.finder` | Finder view/prefs | `finder.txt` |
| `com.apple.dock` | Dock + hot corners | `dock.txt` |
| `com.apple.symbolichotkeys` | system keyboard shortcuts | `symbolichotkeys.txt` |
| `com.apple.screencapture` | screenshot location/format | `screencapture.txt` |
| `com.apple.AppleMultitouchTrackpad` + `…AppleBluetoothMultitouch.trackpad` | trackpad | `trackpad.txt` |
| `com.apple.HIToolbox` | input sources / keyboard layouts | `hitoolbox.txt` |
| `com.apple.Spotlight` | Spotlight categories | `spotlight.txt` |
| (all domains) | catch-all — grep for anything else | `all-defaults.txt`, `defaults-domains.txt` |

To re-apply any single tweak: find the line in the captured file and turn it into a
`defaults write <domain> <key> -<type> <value>`. Apply only the ones you deliberately
changed — don't blanket-restore, or you'll import old cruft.
