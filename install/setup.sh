git submodule init
git submodule update

# 1. Install depenenciess
bash ./install-deps.sh
bash ./install-deps-macos.sh

# 2. Install dotfiles
bash ./bootstrap.sh
