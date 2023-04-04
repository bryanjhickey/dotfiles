#!/bin/zsh

#if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#    source ./install-deps-linux.sh
#elif [[ "$OSTYPE" == "darwin"* ]]; then
#    source ./install-deps-macos.sh
#fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

source $HOME/.asdf/asdf.sh

asdf plugin add nodejs
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 18.15.0
asdf global nodejs $(asdf list nodejs | tail -1 | sed 's/^ *//g')

npm install -g git-branch-utils

