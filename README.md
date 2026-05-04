# Dotfiles

Personal macOS development environment managed with [GNU Stow](https://www.gnu.org/software/stow/) and [Homebrew](https://brew.sh/).

## Bootstrap

> **Read [`install.sh`](install.sh) before running it.** It will warn you too.

```bash
git clone https://github.com/bryanjhickey/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

`install.sh` is safe to re-run after pulling new commits — most steps are idempotent, the rest are convergent (do work only when something's actually missing or out of date):

1. **Xcode CLT** — `xcode-select --install` (no-op if already installed)
2. **Homebrew + Brewfile** — installs Homebrew if missing, then runs the wrapped `brewfile_install` (missing-items preview, real-time per-package output, timed pass/fail summary)
3. **Stow** — symlinks `zsh`, `git`, `iterm2`, `macos`, `espanso` packages into `$HOME`
4. **XDG LaunchAgent** — bootstraps `dotfiles.xdg-env.plist` and exports XDG vars to the current GUI session so iTerm2/Espanso/etc. see them at launch
5. **Node.js** — latest version via `asdf`
6. **fzf-git** — clones the fzf-git keybindings into `~/.config/fzf/`
7. **bat theme** — downloads Tokyo Night `tmTheme` and rebuilds bat's syntax cache
8. **macOS defaults** *(commented out by default)* — uncomment the lines at the bottom of `install.sh` to apply opinionated system preferences

## What's Included

### Shell (zsh)

- XDG-compliant config (`~/.config/zsh/`)
- [Starship](https://starship.rs/) prompt with git status
- [fzf](https://github.com/junegunn/fzf) fuzzy finder with [fd](https://github.com/sharkdp/fd) backend and [fzf-git.sh](https://github.com/junegunn/fzf-git.sh) integration
- [zoxide](https://github.com/ajeetdsouza/zoxide) for smarter `cd`
- [eza](https://eza.rocks/) (better `ls`), [bat](https://github.com/sharkdp/bat) (better `cat`), [thefuck](https://github.com/nvbn/thefuck) (typo corrector)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [direnv](https://direnv.net/) for per-directory env vars
- Daily Homebrew maintenance in the background

### Git

- [delta](https://github.com/dandavella/delta) for side-by-side diffs with line numbers
- Useful aliases (`co`, `ci`, `st`, `br`, `lg`, `grog`)
- zdiff3 merge conflict style

### Terminal (iTerm2)

- [iTerm2](https://iterm2.com/) with [Monokai Pro](https://monokai.pro/) and Octagon `.itermcolors` presets
- [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts) for icon glyphs in `eza`, Powerlevel10k, etc.
- Optional plist sync to dotfiles via iTerm2's "Load preferences from a custom folder" setting (see [iTerm2 Setup](#iterm2-setup) below)

### Text Expansion (Espanso)

- [Espanso](https://espanso.org/) v2 layout — `config/default.yml` for global settings, `match/base.yml` for triggers
- Built-in triggers for ISO date, time stamps, contact details (emails, phone), and reference numbers
- `match/secrets.yml` is reserved for sensitive triggers (kept local, not symlinked, not committed)

### macOS Defaults

Opinionated system preferences (disabled in `install.sh` by default — uncomment to enable):

- Fast key repeat, tap-to-click trackpad
- Finder: show hidden files, full path in title bar, list view
- Disable smart quotes/dashes/autocorrect (for coding)
- Screenshots as PNG to Desktop
- And more — see `scripts/set-defaults.sh`

### macOS LaunchAgent

`dotfiles.xdg-env.plist` exports `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, and `XDG_STATE_HOME` to the GUI session at login. Without this, GUI-launched apps (Finder/Dock-launched Electron apps, etc.) don't inherit the XDG vars from your shell config and fall back to legacy paths.

### Brewfile

All formulae, casks, and Mac App Store apps. Highlights:

- **Dev tools**: git, gh, pnpm, asdf, Docker, Biome, Stripe CLI, Claude Code, uv, railway, ngrok
- **CLI**: fzf, fd, ripgrep, bat, eza, zoxide, lazygit, jq, tmux, starship
- **Apps**: VS Code, iTerm2, Figma, Linear, Obsidian, Raycast, Espanso
- **Comms**: Microsoft Teams, WhatsApp, Zoom
- **MAS**: Bitwarden, CleanMyMac, WhatsApp

## Structure

```
dotfiles/
├── Brewfile                    # Homebrew dependencies
├── install.sh                  # One-shot bootstrap script
├── scripts/
│   ├── set-defaults.sh         # macOS system preferences
│   └── set-hostname.sh         # Fix macOS hostname drift
├── git/
│   └── .config/git/
│       ├── config              # Git config (aliases, delta, user)
│       └── ignore              # Global gitignore
├── espanso/
│   └── Library/Application Support/espanso/
│       ├── config/default.yml  # Global Espanso settings
│       └── match/base.yml      # Text-expansion triggers (secrets stay in match/secrets.yml — local only)
├── iterm2/
│   └── .config/iterm2/
│       ├── Monokai Pro.itermcolors          # Color preset (import via Settings → Profiles → Colors)
│       └── Monokai Pro Octagon.itermcolors  # Alternative Monokai Pro variant
├── macos/
│   └── Library/LaunchAgents/
│       └── dotfiles.xdg-env.plist  # Exports XDG_* to GUI apps launched from Finder/Dock
└── zsh/
    ├── .zshenv                 # Sets XDG dirs and ZDOTDIR
    └── .config/zsh/
        ├── .zprofile           # Homebrew and asdf PATH setup
        └── .zshrc              # Aliases, plugins, tool inits
```

[GNU Stow](https://www.gnu.org/software/stow/) manages symlinks. Each top-level directory (`zsh/`, `git/`, etc.) is a Stow package — its contents mirror the structure they should have relative to `$HOME`. Running `stow --target="$HOME" zsh` from the repo root creates:

- `~/.zshenv` → `dotfiles/zsh/.zshenv`
- `~/.config/zsh/.zshrc` → `dotfiles/zsh/.config/zsh/.zshrc`
- `~/.config/zsh/.zprofile` → `dotfiles/zsh/.config/zsh/.zprofile`

Always pass `--target="$HOME"`. Stow's default target is the parent of the current directory (i.e. `~/code/`), which would land symlinks in the wrong place.

## iTerm2 Setup

Some iTerm2 settings live in a binary plist that's not worth tracking, so the dotfiles ship the colour presets and you wire them up once via the UI:

1. **Color preset.** `Settings → Profiles → Colors → Color Presets → Import…` and pick `~/.config/iterm2/Monokai Pro.itermcolors` (or the Octagon variant). Then `Color Presets → Monokai Pro` to apply.
2. **Font.** `Settings → Profiles → Text → Font → MesloLGS Nerd Font, 13pt`. Tick "Use a different font for non-ASCII text" off.
3. **Padding / window.** `Settings → Profiles → Window → Transparency 0%, Blur off, Columns 120, Rows 36` (taste).
4. **Working directory.** `Settings → Profiles → General → Working Directory → Reuse previous session's directory` so new tabs open where you were.
5. **(Optional) Track all prefs in dotfiles.** Open `Settings (Cmd+,) → General → Preferences` (the sub-tab inside the General pane). Tick `Load preferences from a custom folder or URL`, click the folder button and pick `~/.config/iterm2/`. iTerm2 will offer to copy current settings into that folder — accept. Then tick `Save changes to folder when iTerm2 quits`. After that the binary plist syncs to the repo and you can commit it. Skip this if you'd rather keep prefs out of git — the colour presets alone reproduce the theme on a fresh machine.

## Adding New Configs

To manage a new tool's config (e.g. `starship`):

1. Create the directory structure mirroring where the config lives relative to `$HOME`:

   ```bash
   mkdir -p starship/.config
   mv ~/.config/starship.toml starship/.config/starship.toml
   ```

2. Stow it:

   ```bash
   stow --target="$HOME" starship
   ```

3. Add the package name to the `stow` line in [`install.sh`](install.sh) so a fresh bootstrap picks it up.
4. Add any new dependencies to `Brewfile` and run `brew bundle`.

### Handling secrets

Any config file you stow into place is a symlink back into the (committed) repo, so anything you put in it ends up in git history. For sensitive triggers, tokens, or paths:

- Espanso reads every `*.yml` in `match/`, so put secrets in `match/secrets.yml` as a real local file (not symlinked, not in the repo). The `match/base.yml` symlink stays clean.
- For other tools, the same pattern works: keep a real local file alongside the symlinked config, and make sure the tool loads both.

## Updating

After pulling new commits, re-run the bootstrap. Already-installed packages are skipped; correctly-pointed symlinks are left alone. Casks with a newer upstream version will upgrade. **Don't run `./install.sh` while another `brew bundle` (or the daily `brew upgrade` from `.zshrc`) is in flight** — Homebrew's per-download lockfile will reject the second one with "process has already locked":

```bash
cd ~/code/dotfiles
git pull
./install.sh
```

Or just the pieces you need:

```bash
brew bundle --file=./Brewfile                                # New dependencies only
stow --target="$HOME" zsh git iterm2 macos espanso           # Re-link (idempotent)
```
