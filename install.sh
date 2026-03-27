#!/bin/zsh

STEP=0
TOTAL=7

progress() {
  STEP=$((STEP + 1))
  printf "\n\033[1;34m[%d/%d]\033[0m \033[1m%s\033[0m\n" "$STEP" "$TOTAL" "$1"
}

red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

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
brew bundle --file=./Brewfile

progress "Linking dotfiles with Stow"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config/git"
stow zsh git

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
echo "  Skipped — uncomment the line below to enable"
# ./scripts/set-defaults.sh
# ./scripts/set-hostname.sh

printf "\n${green}All done! Restart your terminal for changes to take effect.${reset}\n"
