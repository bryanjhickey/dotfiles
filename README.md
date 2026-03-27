# Dotfiles

Personal macOS development environment managed with [GNU Stow](https://www.gnu.org/software/stow/) and [Homebrew](https://brew.sh/).

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

### macOS Defaults

Opinionated system preferences (disabled in `install.sh` by default — uncomment to enable):

- Fast key repeat, tap-to-click trackpad
- Finder: show hidden files, full path in title bar, list view
- Disable smart quotes/dashes/autocorrect (for coding)
- Screenshots as PNG to Desktop
- And more — see `scripts/set-defaults.sh`

### Brewfile

All formulae, casks, and Mac App Store apps. Covers:

- **Dev tools**: git, gh, pnpm, asdf, Docker, Biome, Stripe CLI, Claude Code
- **Terminal**: fzf, fd, ripgrep, bat, eza, zoxide, lazygit, jq
- **Apps**: VS Code, Warp, Figma, Linear, Obsidian, Raycast, Slack, and more

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
└── zsh/
    ├── .zshenv                 # Sets XDG dirs and ZDOTDIR
    └── .config/zsh/
        ├── .zprofile           # Homebrew and asdf PATH setup
        └── .zshrc              # Aliases, plugins, tool inits
```

[GNU Stow](https://www.gnu.org/software/stow/) manages symlinks. Each top-level directory (`zsh/`, `git/`) is a Stow package — its contents mirror the structure they should have relative to `$HOME`. Running `stow zsh` from the repo root creates:

- `~/.zshenv` → `dotfiles/zsh/.zshenv`
- `~/.config/zsh/.zshrc` → `dotfiles/zsh/.config/zsh/.zshrc`
- `~/.config/zsh/.zprofile` → `dotfiles/zsh/.config/zsh/.zprofile`

## Setup on a Fresh Mac

> **Read `install.sh` before running it.** It will warn you too.

```bash
git clone https://github.com/bryanjhickey/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

The script will:

1. Install Xcode command line tools
2. Install Homebrew and all dependencies from `Brewfile`
3. Symlink dotfiles into place via `stow zsh git`
4. Install the latest Node.js via asdf
5. Clone the fzf-git plugin
6. Install the bat Tokyo Night theme

Restart your terminal when it's done.

## Adding New Configs

To manage a new tool's config (e.g. `starship`):

1. Create the directory structure mirroring where the config lives relative to `$HOME`:
   ```bash
   mkdir -p starship/.config
   mv ~/.config/starship.toml starship/.config/starship.toml
   ```
2. Stow it:
   ```bash
   stow starship
   ```
3. Add any new dependencies to `Brewfile` and run `brew bundle`.

## Updating

```bash
cd ~/code/dotfiles
brew bundle --file=./Brewfile    # Install any new deps
stow zsh git                     # Re-link (idempotent)
```
