source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="cobalt2"


source_if_exists $HOME/.env.sh
source_if_exists ~/Code/dotfiles/zsh/history.zsh
source_if_exists ~/Code/dotfiles/zsh/git.zsh
source_if_exists ~/Code/dotfiles/zsh/aliases.zsh
source_if_exists /usr/local/etc/profile.d/z.sh
source_if_exists /opt/homebrew/etc/profile.d/z.sh

if type "direnv" > /dev/null; then
    eval "$(direnv hook zsh)"
fi
. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# precmd() {
#     source $DOTFILES/zsh/aliases.zsh
# }

VSCODE=code

export PATH="$PATH:/usr/local/sbin:$DOTFILES/bin:$HOME/.local/bin"

plugins=(
  git
  bundler
  1password
  dotenv
  macos
  rake
  last-working-dir
  web-search
  extract
  history
  sudo
  vscode
  asdf
)

source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/opt/curl/bin:$PATH"


# pnpm
export PNPM_HOME="/Users/bjh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/bjh/.bun/_bun" ] && source "/Users/bjh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. /opt/homebrew/opt/asdf/libexec/asdf.sh
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"