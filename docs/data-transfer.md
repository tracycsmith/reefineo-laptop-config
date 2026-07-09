# Data Transfer — External Drive or Network (no Migration Assistant)

We are **not** using Migration Assistant. User data moves deliberately, either through an
external drive or directly over the network with `rsync`. This is the manifest of *what*
to copy, *how* to copy it, and *how to verify* before the old machine gets wiped.

Apps and settings are handled elsewhere (`Brewfile`, `scripts/`, `docs/macos-settings.md`).
This doc is **user data only** — the stuff that can't be reinstalled.

---

## 1. What to copy (deliberate list)

Copy only what you actually want — this is the moment to leave junk behind.

- [ ] `~/Documents` — includes the Obsidian vault at `~/Documents/Obsidian/Personal`
- [ ] `~/Downloads/Personal` — watched by the apple-card-filer launch agent
- [ ] `~/Desktop` — sweep for anything real; drop the clutter
- [ ] `~/Pictures` / **Photos library** — confirm whether it's in iCloud Photos first; if
      so, sign into iCloud on the new machine instead of copying the `.photoslibrary`
- [ ] `~/Movies`, `~/Music` (local files only — not streaming caches) — as needed
- [ ] Repo `exports/` folder — brew dump, pg dump, pm2 config, macos-settings, iTerm2/Raycast
      exports (already in the repo, but confirm it made it into git or copy it)
- [ ] Any deliberately-chosen app-support folders (NOT wholesale `~/Library`) — e.g. a
      specific app's data you know you need. Default: skip `~/Library` entirely.

### Do NOT copy

- `~/Library` wholesale — this is how cruft/settings-rot comes over. Re-apply settings via
  `docs/macos-settings.md` instead.
- Anything reinstallable (apps, Homebrew, node_modules, caches).
- Secrets — they live in 1Password (see `docs/00-pre-plan.md`), not on the drive.

## 2. Pre-flight sweep (old machine)

Before copying, catch stragglers:

```sh
# Uncommitted work anywhere under ~/Development
find ~/Development -type d -name .git -maxdepth 4 -execdir sh -c \
  'test -n "$(git status --porcelain)" && echo "DIRTY: $PWD"' \;

# Eyeball the loose folders
ls -la ~/Desktop ~/Downloads ~/Documents
```

Commit/push anything dirty so it comes back via `scripts/05-repos.sh` — not the drive.

## 3. How to copy — Option A: external drive

Plug in the drive (say it mounts at `/Volumes/Migrate`).

```sh
DEST="/Volumes/Migrate/laptop-2026"
mkdir -p "$DEST"

# -a preserves perms/times/symlinks; -h human sizes; -P shows progress + resumes;
# --exclude keeps caches/junk out. Trailing slash on source copies contents.
rsync -ahP \
  --exclude '.DS_Store' --exclude 'node_modules' --exclude '.Trash' \
  ~/Documents "$DEST/Documents"
rsync -ahP --exclude '.DS_Store' ~/Downloads/Personal "$DEST/Downloads-Personal"
rsync -ahP --exclude '.DS_Store' ~/Desktop "$DEST/Desktop"
```

Repeat per folder from §1. Re-running is safe and only copies changes (good for a final
top-up right before switching).

**On the NEW machine** (drive mounted):

```sh
SRC="/Volumes/Migrate/laptop-2026"
rsync -ahP "$SRC/Documents/"          ~/Documents/
rsync -ahP "$SRC/Downloads-Personal/" ~/Downloads/Personal/
rsync -ahP "$SRC/Desktop/"            ~/Desktop/
```

## 4. How to copy — Option B: network (rsync over SSH)

Both machines on the same LAN. Enable **System Settings → General → Sharing → Remote Login**
on the OLD machine, note its address (`OLDHOST.local` or its IP), then **pull from the NEW
machine**:

```sh
OLD="tracy@OLDHOST.local"      # old machine's user@host

rsync -ahP -e ssh --exclude '.DS_Store' --exclude 'node_modules' \
  "$OLD:Documents/"          ~/Documents/
rsync -ahP -e ssh "$OLD:Downloads/Personal/" ~/Downloads/Personal/
rsync -ahP -e ssh "$OLD:Desktop/"            ~/Desktop/
```

Pulling (new ← old) is safer than pushing: the new machine is the clean target and you can
re-run to top up.

## 5. Verify before wiping

```sh
# Compare counts + total size, source vs. destination
du -sh ~/Documents            # on each machine
find ~/Documents -type f | wc -l

# Spot-check a few known files open correctly (Obsidian vault, a recent doc, a photo)
```

Only after data is verified **and** the Week-1 shakedown in `docs/02-post-plan.md` passes
should the old machine be wiped and sold.
