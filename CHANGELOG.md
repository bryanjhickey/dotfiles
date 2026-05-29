# Changelog

Notable changes to this dotfiles repo, newest first. Format loosely based on
[Keep a Changelog](https://keepachangelog.com); since there are no semver
releases, entries are dated.

## 2026-05-29 — Derive the LaunchAgent bootstrap list

### Changed

- `install.sh` now loops over `~/Library/LaunchAgents/dotfiles.*.plist` (zsh `(N)` null-glob) instead of bootstrapping each agent by name. A new `dotfiles.*.plist` dropped into the `macos` package is picked up automatically — no hardcoded list to edit. The `mkdir` (anti-folding) and `stow` lines are intentionally left explicit: the stow package list can't be auto-derived (not every top-level dir is a package).

## 2026-05-29 — Finish dropping calibre-import

The `calibre-import` LaunchAgent was deleted on 2026-05-20, but its caller, script, and docs were left dangling. Completing that removal so nothing points at a file that no longer exists.

### Removed

- `scripts/inbox-to-calibre.sh` — the ebook auto-import script. Its only trigger (the watch agent) was already gone, yet the docstring still claimed it was plist-triggered.
- `install.sh` `launchctl bootstrap` line for `dotfiles.calibre-import.plist` — bootstrapped a file that hadn't existed since 2026-05-20 (a silent no-op).
- `README.md` references — the Calibre auto-import bullet, the "Calibre inbox importer" agent mention (now two agents, not three), and `dotfiles.calibre-import.plist` from the install step's bootstrap list.

Calibre and Adobe Digital Editions casks stay in the Brewfile — the app is still installed, just no longer managed by the dotfiles.

## 2026-05-29 — Unify journal capture

### Added

- **`scripts/journal.sh`** — the single home for plain-text journal capture. Two subcommands: `note <text…>` appends a timestamped line (`YYYY-MM-DD HH:MM — text`), `stamp` appends a day header (`## Friday 29 May 2026`). The path to `~/Documents/journal.md` lives here and nowhere else.
- **[`CONTEXT.md`](CONTEXT.md)** — domain vocabulary for the repo, starting with the journal-capture terms (Journal, Note, Stamp, journal module) and the Journal-vs-Obsidian distinction.

### Changed

- `note()` in [`zsh/.config/zsh/notes.zsh`](zsh/.config/zsh/notes.zsh), the Raycast `journal` command, and the `dotfiles.daily-journal.plist` LaunchAgent are now thin adapters over `scripts/journal.sh`. Each had reimplemented the append logic, and the plist's comment had drifted — it claimed to route through `note` but inlined its own `printf` with a different format. One module, one format, one place to change. `obs`/`daily` (Obsidian capture) are untouched.

### Removed

- ~14 lines of duplicated journal-append logic across the three callers.

## 2026-05-08 — Drop Karabiner + Hammerspoon

### Removed

- `karabiner/` Stow package and the `karabiner-elements` Brewfile cask. Karabiner-Elements writes to `~/.config/karabiner/karabiner.json` directly, so the live config and `automatic_backups/` remain on disk untouched.
- `hammerspoon/` Stow package (the five Lua modules — `init`, `windows`, `apps`, `darkmode`, `reload`) and the `hammerspoon` Brewfile cask.
- Hammerspoon login-item line from `scripts/set-defaults.sh`.
- Karabiner/Hammerspoon entries from `install.sh` (mkdir, stow line, XDG comment) and from `README.md` (Keyboard & windowing section, first-time setup steps, structure tree).

## 2026-05-04 — Multi-phase non-developer rollout

Four self-contained phases shipped over an evening, each its own commit.

### Added

- **Karabiner-Elements** package ([`karabiner/.config/karabiner/karabiner.json`](karabiner/.config/karabiner/karabiner.json)) — Caps Lock as Escape on tap and Hyper (⌃⌥⇧⌘) on hold; Shift+Shift recovers Caps Lock; standard fn function-key mapping.
- **Hammerspoon** package — five Lua modules under [`hammerspoon/.hammerspoon/`](hammerspoon/.hammerspoon/):
  - `init.lua` defines the Hyper modifier set, loads modules, shows a load toast.
  - `windows.lua` — Hyper+H/J/K/L for halves, U/I/N/, for quarters, M maximise, C centre-70%, ←/→ to move between monitors.
  - `apps.lua` — table-driven Hyper+letter app focus/launch (`B` Chrome, `T` iTerm, `E` VS Code, `O` Obsidian, `S` Slack, `G` Logos, `Z` Zotero, `F` Finder, `P` Preview, `W` WhatsApp, `0` for `hs.expose`).
  - `darkmode.lua` — listens for `AppleInterfaceThemeChangedNotification` and swaps wallpaper between black/silver. Replaces the deleted `dark-mode-notify` Swift+plist chain.
  - `reload.lua` — `hs.pathwatcher` on `~/.hammerspoon/`, calls `hs.reload()` on save.
- **Raycast script commands** ([`raycast/.config/raycast/scripts/`](raycast/.config/raycast/scripts/)) — `daily-note.sh` opens `obsidian://daily`; `journal.sh` appends a timestamped line to `~/Documents/journal.md`; `weather.sh` fetches wttr.in (refresh every 30 min); `lock-screen.sh` runs `pmset displaysleepnow`.
- **`note` / `obs` / `daily` shell quick-capture** ([`zsh/.config/zsh/notes.zsh`](zsh/.config/zsh/notes.zsh)) — sourced from `.zshrc`. `note` always works; `obs` requires `$OBSIDIAN_VAULT`; `daily` opens today's note via the URL scheme.
- **Espanso study triggers** ([`espanso/.../match/study.yml`](espanso/Library/Application%20Support/espanso/match/study.yml)) — markdown footnote pair, bracketed scripture reference, ~20 Bible book abbreviations, citation skeleton.
- **Calibre auto-import** — [`scripts/inbox-to-calibre.sh`](scripts/inbox-to-calibre.sh) plus a LaunchAgent watch `~/Downloads` and `~/Documents/Digital Editions/`. New ebook-shaped files are moved into the Calibre library via `calibredb add`. Skips silently while Calibre is open and re-fires on next file add. Notifies via `osascript` on completion.
- **Daily-journal LaunchAgent** ([`dotfiles.daily-journal.plist`](macos/Library/LaunchAgents/dotfiles.daily-journal.plist)) — fires at 06:00 daily, appends a date header (`## Friday 04 May 2026`) to `~/Documents/journal.md`.
- **SSH config** package ([`ssh/.ssh/config`](ssh/.ssh/config)) — `UseKeychain`, `AddKeysToAgent`, ServerAlive timers, GitHub host alias. Ends with `Include ~/.ssh/config.local` for per-machine overrides (gitignored).
- **Login items** block in `set-defaults.sh` — registers Bitwarden, Stats, Raycast, Hammerspoon via `osascript` (idempotent — checks `exists login item` first).
- **Time Machine excludes** script ([`scripts/time-machine-excludes.sh`](scripts/time-machine-excludes.sh)) — `tmutil addexclusion` for build artefacts, language toolchain caches, Docker container dirs, Homebrew cellar, and a `~/code/*/` sweep for `node_modules`, `.next`, `dist`, `build`, `target`, `.turbo`, `.nuxt`, `.svelte-kit`, `.venv`, `__pycache__`.
- **Obsidian scaffold** ([`obsidian/README.md`](obsidian/README.md)) — package documentation explaining what to track (`community-plugins.json`, `hotkeys.json`, snippets/templates) and what to ignore (`workspace.json`, plugin caches, theme code) when a vault is wired up later.

### Changed

- **`scripts/set-defaults.sh`**: added an Australian-locale block (en-AU, AUD, Centimeters, Celsius, DD/MM/YYYY date format) and a Safari privacy block (no autofill of credentials/cards/contacts/forms, Do-Not-Track, full-URL display, Develop menu enabled).
- **Brewfile**: added `karabiner-elements`, `hammerspoon`, `calibre` casks.
- **`install.sh`**: stow line now covers `zsh git iterm2 macos espanso karabiner hammerspoon raycast ssh`. The "Loading LaunchAgents" step bootstraps `dotfiles.{xdg-env,calibre-import,daily-journal}.plist`.
- **README.md**: bootstrap section moved to the top with an 8-step description; new "What's Included" sections for Terminal, Keyboard & Window Automation, Notes & Reading, SSH, System Maintenance.
- **`.gitignore`**: defensive globs for SSH keys (`id_rsa`, `id_ed25519`, both with and without `.pub`), `*.pem`, `*.key`, `known_hosts`, `authorized_keys`, plus `ssh/.ssh/config.local`.

### Removed

- Entire `install/` directory (953-line `macos.sh` plus four pre-Stow bootstrap scripts, all orphaned and unreferenced).
- `scripts/dark-mode-notify.{swift,plist}`, `scripts/onSwitchDarkMode.sh`, `scripts/{pre,post}-link.sh`, `scripts/links.prop` — broken third-party Swift listener whose plist hardcoded `/Users/bryanjhickey/`. Replaced by `hammerspoon/.hammerspoon/darkmode.lua`.
- `scripts/macos-hide-menubar.applescript` — unused, never wired anywhere.

### Fixed

- **`scripts/set-defaults.sh` line 17** used Unicode smart quotes (`‘…’`) instead of straight quotes, which would have failed shell parsing on the `osascript -e` invocation. The bug had been there since the file was first added.
- Step counter in `set-defaults.sh` (`TOTAL=11`) didn't match the 10 actual `progress()` calls. Now correctly `TOTAL=13` after the Aussie locale, Safari privacy, and login-items additions.

### Security

- `match/secrets.yml` pattern documented in `obsidian/README.md` so future packages know to keep PII / tokens / passwords in local-only files outside git.

## 2026-05-02 — Hyper → iTerm2 + Espanso restructure + visual brew bundle

### Added

- **iTerm2** Stow package ([`iterm2/.config/iterm2/`](iterm2/.config/iterm2/)) with Monokai Pro and Monokai Pro Octagon `.itermcolors` colour presets.
- **Espanso v2 layout** ([`espanso/Library/Application Support/espanso/`](espanso/Library/Application%20Support/espanso/)) — `config/default.yml` for global settings, `match/base.yml` for date/time triggers. PII (emails, phone, ABN) split into a local-only `match/secrets.yml` that's not symlinked, not in the repo, and gitignored as belt-and-braces.
- **macOS LaunchAgent** ([`macos/Library/LaunchAgents/dotfiles.xdg-env.plist`](macos/Library/LaunchAgents/dotfiles.xdg-env.plist)) — exports `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, `XDG_STATE_HOME` to the GUI session at login. Without this, GUI-launched apps (Hyper/Electron etc.) don't inherit the XDG vars from `zsh/.zshenv` and fall back to legacy paths. See [vercel/hyper#137](https://github.com/vercel/hyper/issues/137).
- **`brewfile_install` wrapper** in `install.sh` — preflight `brew bundle check --verbose` enumerates missing items as a checklist with counts; runs `brew bundle install --verbose` so per-package output streams; ends with a timed pass/fail summary.

### Changed

- **Brewfile** synced to actually-installed packages. Removed stale entries (Hyper cask, Calibre, Logos, Logi Options+, Microsoft Office, OneDrive, Wispr Flow). Added `iterm2`, `affinity`, `antigravity`, `cleanmymac`, `firefox`, `microsoft-teams`, `ngrok` casks; `biome`, `coreutils`, `curl`, `docker-compose`, `git-filter-repo`, `pinentry-mac`, `poppler`, `python@3.11`, `railway`, `starship`, `tmux`, `uv` formulae; MAS entries for Bitwarden and WhatsApp.
- **`.gitignore`** reinforced against the iTerm2 "Save changes to folder" feature, which created an `AppSupport` symlink back to `~/Library/Application Support/iTerm2/` (exposing saved sessions, Notes, scripts, profile data through the repo path) plus a `sockets/` directory.

### Removed

- Hyper `hyper/` Stow package (Hyper hadn't seen a meaningful upstream commit in ~2 years; the canary 4.x channel rolled back to 3.4.1 mid-debug; its config-format whiplash made it a poor target).

## 2026-03-27 — Stow-based structure overhaul

Repo reorganised around GNU Stow + Brewfile + a single `install.sh` bootstrap. Pre-Stow link scripts retired; each tracked tool became a Stow package whose internal layout mirrors where its files should land relative to `$HOME`. Starship prompt added. README rewritten.

(See [`a43a86b`](https://github.com/bryanjhickey/dotfiles/commit/a43a86b) for the full diff. Earlier history pre-dates this changelog.)
