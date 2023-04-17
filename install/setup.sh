git submodule init
git submodule update

# 1. Install depenenciess
bash $DOTFILES/install/install-deps.sh
bash $DOTFILES/install/install-deps-macos.sh

# 2. Install dotfiles
bash $DOTFILES/install/bootstrap.sh
