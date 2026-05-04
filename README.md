# Dotfiles

My personal macOS setup — the shell I live in, the terminal I look at, the keyboard tricks I'd rather not re-learn on a new machine, and the small automations that take a polite-but-bare laptop and turn it into something I want to use. Managed with [GNU Stow](https://www.gnu.org/software/stow/) for symlinks and [Homebrew](https://brew.sh/) for everything installable.

See [`CHANGELOG.md`](CHANGELOG.md) for what's changed lately.

## Quick start

```bash
git clone https://github.com/bryanjhickey/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

`install.sh` is safe to re-run. Read it before you run it. There's a [step-by-step breakdown further down](#what-installsh-actually-does) if you'd rather know what you're agreeing to first.

A few apps need permission grants Stow can't issue (kernel driver for Karabiner, Accessibility for Hammerspoon, etc.) — see [First-time setup on a fresh Mac](#first-time-setup-on-a-fresh-mac) below.

## The setup, briefly

### Shell I live in

[zsh](https://www.zsh.org/) configured the [XDG-compliant way](https://wiki.archlinux.org/title/XDG_Base_Directory) — only `~/.zshenv` lives at `$HOME`; everything else is under `~/.config/zsh/`. The shell does most of my non-coding work too (file navigation, scratch arithmetic, ad-hoc data wrangling), so it's worth investing in.

The pieces I'd be lost without:

- **[Starship](https://starship.rs/)** prompt. Git status, language version detection, no flicker, no `.zshrc` mess. Replaced an oh-my-zsh setup that had grown spooky.
- **[fzf](https://github.com/junegunn/fzf)** as the universal fuzzy picker, with **[fd](https://github.com/sharkdp/fd)** as its filesystem backend (faster than `find`, sane defaults). Plus **[fzf-git.sh](https://github.com/junegunn/fzf-git.sh)** for `Ctrl-G`-flavoured git pickers — branch, file, hash, remote, all interactive. Worth the keybind by itself.
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** in place of `cd`. Aliased so `cd foo` jumps to the project I've visited most that matches "foo". Once you internalise it, going back to `cd ../../some/path` feels archaic.
- **[eza](https://eza.rocks/)** in place of `ls` (icons + colour, tree mode is one flag away).
- **[bat](https://github.com/sharkdp/bat)** in place of `cat` (syntax highlighting, page on long output).
- **[thefuck](https://github.com/nvbn/thefuck)** for typo correction. Aliased to `fk` so muscle memory doesn't fight me.
- **[direnv](https://direnv.net/)** for per-directory env vars — secrets, project-specific PATH, that sort of thing.
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** + **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** for fish-like ergonomics in zsh.

There's also a small daily-Homebrew-maintenance block in `.zshrc` that runs `brew update && brew upgrade && brew cleanup` in the background, gated by a once-per-day stamp file. Saves the "wait, when did I last update brew" stutter.

### The terminal itself

[**iTerm2**](https://iterm2.com/) — actively maintained, native (not Electron), and forgiving of plugin experiments. I tried Hyper for a while and bailed when its canary 4.x channel rolled back to 3.4.1 mid-debug; the upstream repo hadn't seen a meaningful commit in close to two years.

The dotfiles ship two **Monokai Pro** colour presets (the standard one and the Octagon variant) plus the **MesloLGS Nerd Font** cask, which gives `eza` and Powerlevel10k their icon glyphs. iTerm2 stores most of its other prefs in a binary plist that's not really worth versioning, so the dotfiles deliberately skip that — there's a one-time UI walkthrough in [First-time setup](#first-time-setup-on-a-fresh-mac).

### Git, tuned for actually reading diffs

- [**delta**](https://github.com/dandavella/delta) as the diff pager — side-by-side, syntax-highlighted, line numbers. Once you've used it you can't go back.
- **`merge.conflictstyle = zdiff3`** — three-way conflict markers. Saved me hours on gnarly merges; if you've never tried it, do.
- Short aliases: `co`, `ci`, `st`, `br`, plus `lg` (compact graph log) and `grog` (the same but more decorated). Nothing fancy, just muscle memory.
- A global `~/.config/git/ignore` so I don't `.gitignore`-update every project for the same `.DS_Store` and editor-swap-files.

### Keyboard and windowing

The combination that turned macOS from frustrating to fluent for me:

- **[Karabiner-Elements](https://karabiner-elements.pqrs.org/)** — Caps Lock as Escape on tap, **Hyper** (⌃⌥⇧⌘) on hold. Caps Lock by itself is wasted real estate; turning it into a Vim-friendly Escape *and* a never-conflicts modifier earns it back. Pressing both Shifts at once still gives me Caps Lock when I want it.
- **[Hammerspoon](https://www.hammerspoon.org/)** — Lua-driven window and app automation. I use it for:
  - Window tiling: `Hyper+H/J/K/L` for halves, `U/I/N/,` for quarters, `M` to maximise, `C` for a centred 70%, `←/→` to bounce between monitors. Replaces Spectacle/Magnet with something I can actually script.
  - App jumps: `Hyper+B` Chrome, `T` iTerm, `E` VS Code, `O` Obsidian, `G` Logos, `Z` Zotero — focuses or launches, never both.
  - System dark/light mode listener that swaps the wallpaper. (This used to be a third-party Swift binary with a hardcoded `/Users/andrew/` plist that had been broken for who knows how long. Hammerspoon does it in 20 lines of Lua.)
  - Auto-reload when I edit a config file — so iterating on bindings doesn't mean menubar clicks.
- **[Raycast](https://www.raycast.com/)** — Spotlight replacement and command palette for everything else. The dotfiles ship a few script commands: `daily-note` (opens my Obsidian daily note), `journal` (timestamped capture to a file), `weather` (wttr.in via curl), `lock-screen`. Raycast preferences themselves live in a sandboxed app container and don't version cleanly — Raycast Pro's cloud sync handles that side.

### Capturing thoughts, scriptures, and books

I do a lot of reading and note-taking — both for theological study at Ridley and for general knowledge work. The setup leans into that:

- **[Espanso](https://espanso.org/)** for text expansion. The dotfiles ship `match/base.yml` (date and time stamps for daily notes — `;date`, `ddate`, `ttime`) and `match/study.yml` (markdown footnote pair, bracketed scripture references, ~20 Bible book abbreviations like `;gen` → `Genesis`, plus a citation skeleton). Anything sensitive (personal email, phone, ABN) lives in a sibling `match/secrets.yml` that's a real local file — not symlinked, not committed, gitignored as belt-and-braces.
- **`note <text>`**, **`obs <text>`**, **`daily`** — three tiny shell functions in [`zsh/.config/zsh/notes.zsh`](zsh/.config/zsh/notes.zsh). `note` always works (appends a timestamped line to `~/Documents/journal.md`); `obs` targets today's daily note inside `$OBSIDIAN_VAULT`; `daily` opens it in Obsidian via the URL scheme. There's a 6am LaunchAgent that drops a date header into `journal.md` automatically so each morning has a clean section to write under.
- **Calibre auto-import.** I read a lot of ebooks, and they accumulate from various sources — Adobe Digital Editions drops them in `~/Documents/Digital Editions/`, sometimes I download direct to `~/Downloads`. A LaunchAgent watches both folders; new `.epub`/`.pdf`/`.mobi` files get piped through `calibredb add` into the library and the originals deleted. Skips silently while Calibre is open and re-fires on the next file event.
- **Obsidian** is installed via the Brewfile but its package is currently a [scaffold/README](obsidian/README.md). I'll wire up the vault when I've decided where it lives — the README documents what's worth tracking (`community-plugins.json`, `hotkeys.json`, snippets, templates) and what to ignore (`workspace.json` and friends rewrite on every focus change — pure diff noise).

### Quiet machine maintenance

The bits that just need to *be there*:

- **macOS LaunchAgent** [`dotfiles.xdg-env.plist`](macos/Library/LaunchAgents/dotfiles.xdg-env.plist) exports `XDG_CONFIG_HOME` and friends to the GUI session at login. macOS GUI apps don't inherit your shell environment — without this, anything you launch from Dock or Finder ignores `$XDG_CONFIG_HOME` even though `.zshenv` sets it. Took me a while to figure out, documented in [vercel/hyper#137](https://github.com/vercel/hyper/issues/137) for context.
- **SSH config** at [`ssh/.ssh/config`](ssh/.ssh/config) — `UseKeychain`, `AddKeysToAgent`, ServerAlive timers, GitHub host alias. Per-machine bits (work hostnames, bastion IPs) go in `~/.ssh/config.local` (gitignored). Defensive `.gitignore` patterns block `id_rsa`, `id_ed25519`, `*.pem`, `*.key`, `known_hosts`, `authorized_keys` from ever being staged.
- **Time Machine excludes** ([`scripts/time-machine-excludes.sh`](scripts/time-machine-excludes.sh)) — `tmutil addexclusion` for build artefacts, language toolchain caches, Docker container dirs, and a `~/code/*/{node_modules,.next,dist,build,target,…}` sweep. Run once after Time Machine is configured; idempotent.
- **macOS defaults** ([`scripts/set-defaults.sh`](scripts/set-defaults.sh)) — opinionated system preferences: fast key repeat, tap-to-click, Finder showing hidden files and full POSIX paths, screenshots as PNG, Australian locale (en-AU, AUD, Centimeters, Celsius, DD/MM/YYYY), Safari privacy (no autofill of credentials/cards/contacts/forms — Bitwarden owns that responsibility), Develop menu, login items for Bitwarden/Stats/Raycast/Hammerspoon. Disabled by default in `install.sh`; uncomment the line at the bottom when you're ready to apply.

### What's in the Brewfile

Roughly 60 entries. The interesting categories:

- **Dev**: git, gh, pnpm, asdf, Docker, Biome, Stripe CLI, Claude Code, uv, Railway, ngrok
- **CLI**: fzf, fd, ripgrep, bat, eza, zoxide, lazygit, jq, tmux, starship
- **Apps**: VS Code, iTerm2, Figma, Linear, Obsidian, Raycast, Espanso, Bitwarden, Calibre
- **Comms**: Microsoft Teams, WhatsApp, Zoom
- **Mac App Store**: Bitwarden, CleanMyMac, WhatsApp

`brew bundle dump --force` keeps `Brewfile` honest when I install something new and forget to add it.

## How the repo is shaped

```
dotfiles/
├── Brewfile             # Homebrew dependencies — single source of truth
├── install.sh           # One-shot bootstrap, safe to re-run
├── scripts/             # set-defaults.sh, set-hostname.sh, time-machine-excludes.sh, inbox-to-calibre.sh
├── zsh/        git/        iterm2/      espanso/
├── karabiner/  hammerspoon/ raycast/    macos/    ssh/    obsidian/
└── CHANGELOG.md
```

Each top-level folder named after a tool is a **Stow package**. Its internal layout mirrors where files should land relative to `$HOME`. So `git/.config/git/config` in the repo becomes `~/.config/git/config` after `stow git`. You don't move files around; you describe where they live.

A few patterns I lean on:

- **Always pass `--target="$HOME"`** to Stow. Its default target is the parent of the current directory (`~/code/`, here), which silently lands symlinks in the wrong place. The bootstrap script always uses the explicit form.
- **Secrets stay local.** Anything sensitive — personal email, phone, work hostnames, throwaway test passwords — goes in a sibling file outside the symlinked one and gets gitignored. Espanso loads every `*.yml` in `match/`, so `match/base.yml` (committed) and `match/secrets.yml` (local-only) coexist. Same pattern for SSH (`config` + `config.local`).
- **LaunchAgents over cron.** macOS doesn't have crontab in any meaningful way; launchd is the right tool. Three personal agents live in [`macos/Library/LaunchAgents/`](macos/Library/LaunchAgents/) — XDG env exporter, Calibre inbox importer, daily journal stamper. Adding new ones is a copy-paste of the plist shape.
- **Idempotent vs convergent.** Most steps in `install.sh` are idempotent (no-op if already done). The Brewfile install is *convergent* — it'll upgrade casks when upstream has a newer version, so it does real work on re-run, just nothing destructive.

## What `install.sh` actually does

Eight steps. Re-runnable.

1. **Xcode CLT** — `xcode-select --install`. No-op if installed.
2. **Homebrew + Brewfile** — installs Homebrew if missing, then runs the wrapped `brewfile_install`: pre-flights `brew bundle check --verbose` to enumerate missing items as a clean checklist, runs the install with real-time per-package output, and prints a timed pass/fail summary at the end.
3. **Stow** — `stow --target="$HOME" zsh git iterm2 macos espanso karabiner hammerspoon raycast ssh`.
4. **LaunchAgents** — bootstraps `dotfiles.xdg-env.plist`, `dotfiles.calibre-import.plist`, `dotfiles.daily-journal.plist` into the user's GUI domain.
5. **Node.js** — latest stable via `asdf`.
6. **fzf-git** — clones [junegunn/fzf-git.sh](https://github.com/junegunn/fzf-git.sh) into `~/.config/fzf/`.
7. **bat theme** — downloads Tokyo Night `tmTheme`, rebuilds bat's syntax cache.
8. **macOS defaults** — opt-in. Read `scripts/set-defaults.sh`, then uncomment the call at the bottom of `install.sh` to enable.

## First-time setup on a fresh Mac

A handful of things macOS won't let an installer do automatically. Each is a one-time click:

1. **Karabiner-Elements** — first launch prompts for kernel driver + Input Monitoring permission via *System Settings → Privacy & Security*. Approve, then verify Caps Lock now sends Escape on tap and Hyper on hold.
2. **Hammerspoon** — first launch prompts for Accessibility permission. Approve, then menu bar icon → *Reload Config*. You'll see a "Hammerspoon: config loaded" toast. Test with `Hyper+H` (focus left half) or `Hyper+M` (maximise).
3. **Raycast** — Settings → Extensions → ⊕ → *Add Script Directory* → `~/.config/raycast/scripts`. The `daily-note`, `journal`, `weather`, `lock-screen` commands appear in search.
4. **iTerm2** — minimal manual config:
   - **Color preset.** Settings → Profiles → Colors → Color Presets → *Import…* → pick `~/.config/iterm2/Monokai Pro.itermcolors` (or the Octagon variant). Then Color Presets → Monokai Pro to apply.
   - **Font.** Settings → Profiles → Text → Font → MesloLGS Nerd Font, 13pt. *Use a different font for non-ASCII text* off.
   - **Working directory.** Settings → Profiles → General → Working Directory → *Reuse previous session's directory*.
   - **Optional plist sync.** Settings → General → Preferences → tick *Load preferences from a custom folder or URL*, point at `~/.config/iterm2/`. iTerm2 will offer to copy current settings into that folder — accept. Then tick *Save changes to folder when iTerm2 quits*. The full plist is now in the repo. Skip this if you'd rather not commit binary settings — the colour presets alone reproduce the theme.

## Adding a new package

To track a new tool's config (`starship` as an example):

1. Mirror the destination path under `$HOME`:
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

For sensitive bits, see the [secrets pattern](#how-the-repo-is-shaped) — keep a sibling local file alongside the symlinked config and gitignore it.

## Updating

After pulling new commits, re-run the bootstrap:

```bash
cd ~/code/dotfiles
git pull
./install.sh
```

Or just the parts you need:

```bash
brew bundle --file=./Brewfile                                                            # New deps only
stow --target="$HOME" zsh git iterm2 macos espanso karabiner hammerspoon raycast ssh     # Re-link
```

**Don't run `./install.sh` while another `brew bundle` is in flight** — the daily `brew upgrade` job in `.zshrc` can collide with it on the same download and you'll get a "process has already locked" error. Wait for the background job to finish (or `pkill -f "brew (bundle|fetch|upgrade)"` if it's stuck) before re-running.
