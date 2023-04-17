#!/bin/zsh

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Powerline fonts
# Remove existing installation
rm -rf $HOME/powerline-fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1 $HOME/powerline-fonts
# install
cd $HOME/powerline-fonts
./install.sh
# clean-up a bitss
cd ..
rm -rf $HOME/powerline-fonts

# Install Oh My Zsh
# Remove existing installation
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
