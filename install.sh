#!/bin/zsh

STEP=0
TOTAL=8

progress() {
  STEP=$((STEP + 1))
  printf "\n\033[1;34m[%d/%d]\033[0m \033[1m%s\033[0m\n" "$STEP" "$TOTAL" "$1"
}

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
dim='\033[2m'
bold='\033[1m'
reset='\033[0m'

# Format a duration in seconds as e.g. "1m 23s" or "12s".
fmt_duration() {
  local s=$1
  if [ "$s" -ge 60 ]; then printf "%dm %ds" $((s / 60)) $((s % 60))
  else printf "%ds" "$s"
  fi
}

# Wrap `brew bundle install` with a missing-items preview, timing, and a
# clear pass/fail summary. Single argument: Brewfile path.
brewfile_install() {
  local brewfile="$1"
  local check missing total start end rc

  printf "  ${dim}Checking Brewfile…${reset}\n"
  check=$(brew bundle check --file="$brewfile" --verbose 2>&1)
  if echo "$check" | grep -q "The Brewfile's dependencies are satisfied."; then
    printf "  ${green}✓${reset} Brewfile already satisfied\n"
    return 0
  fi

  # Brew bundle check --verbose emits lines like:
  #   → Tap homebrew/services needs to be installed.
  #   → Cask iterm2 needs to be installed or updated.
  # Strip the arrow + kind prefix and the trailing reason.
  missing=$(echo "$check" \
    | sed -nE 's/^[^A-Za-z]*(Tap|Formula|Cask|App) (.+) needs to be installed.*/\1\: \2/p')
  total=$(printf "%s" "$missing" | grep -c .)

  if [ "$total" -gt 0 ]; then
    printf "  ${cyan}↻${reset} ${bold}%d${reset} missing:\n" "$total"
    printf "%s\n" "$missing" | while IFS= read -r line; do
      printf "    ${dim}•${reset} %s\n" "$line"
    done
  else
    printf "  ${cyan}↻${reset} Brewfile not satisfied (couldn't enumerate items — running install).\n"
  fi
  printf "  ${dim}────────────────────────────────────${reset}\n"

  start=$(date +%s)
  brew bundle install --file="$brewfile" --verbose
  rc=$?
  end=$(date +%s)

  printf "  ${dim}────────────────────────────────────${reset}\n"
  if [ "$rc" -eq 0 ]; then
    printf "  ${green}✓${reset} Brewfile satisfied in %s\n" "$(fmt_duration $((end - start)))"
  else
    printf "  ${red}✗${reset} brew bundle exited with code %d after %s\n" "$rc" "$(fmt_duration $((end - start)))"
    return "$rc"
  fi
}

echo ""
echo "${red}###############################################${reset}"
echo "${red}#        DO NOT RUN THIS SCRIPT BLINDLY       #${reset}"
echo "${red}#         YOU'LL PROBABLY REGRET IT...        #${reset}"
echo "${red}#                                             #${reset}"
echo "${red}#              READ IT THOROUGHLY             #${reset}"
echo "${red}#         AND EDIT TO SUIT YOUR NEEDS         #${reset}"
echo "${red}###############################################${reset}"
echo ""

progress "Installing Xcode command line tools"
xcode-select --install 2>/dev/null || true

progress "Installing Homebrew and Brewfile"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew analytics off
brewfile_install ./Brewfile

progress "Linking dotfiles with Stow"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/.config/raycast/scripts"
mkdir -p "$HOME/Library/LaunchAgents"
mkdir -p "$HOME/Library/Application Support/espanso/config"
mkdir -p "$HOME/Library/Application Support/espanso/match"
stow --target="$HOME" zsh git iterm2 macos espanso karabiner hammerspoon raycast

progress "Loading XDG LaunchAgent (exports XDG_CONFIG_HOME to GUI apps)"
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/dotfiles.xdg-env.plist" 2>/dev/null || true
launchctl setenv XDG_CONFIG_HOME "$HOME/.config"
launchctl setenv XDG_DATA_HOME "$HOME/.local/share"
launchctl setenv XDG_CACHE_HOME "$HOME/.cache"
launchctl setenv XDG_STATE_HOME "$HOME/.local/state"

progress "Installing Node.js via asdf"
asdf plugin add nodejs 2>/dev/null || true
asdf install nodejs latest
asdf set -u nodejs latest

progress "Installing fzf-git plugin"
if [ ! -d "$HOME/.config/fzf/fzf-git.sh" ]; then
  mkdir -p "$HOME/.config/fzf"
  git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/.config/fzf/fzf-git.sh"
else
  echo "  Already installed, pulling latest..."
  git -C "$HOME/.config/fzf/fzf-git.sh" pull
fi

progress "Installing bat theme"
mkdir -p "$(bat --config-dir)/themes"
curl -so "$(bat --config-dir)/themes/tokyonight_night.tmTheme" \
  https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build

progress "Setting macOS defaults"
# Opt-in. set-defaults.sh applies ~120 `defaults write` calls (Finder, keyboard,
# trackpad, screenshots, Aussie locale, Safari privacy, etc.); set-hostname.sh
# corrects macOS's hostname-suffix drift between Wi-Fi/wired networks. Read
# both before enabling. They prompt for sudo and require a logout to fully
# apply some settings.
echo "  Skipped — uncomment the lines below to enable"
# ./scripts/set-defaults.sh
# ./scripts/set-hostname.sh

printf "\n${green}All done! Restart your terminal for changes to take effect.${reset}\n"
