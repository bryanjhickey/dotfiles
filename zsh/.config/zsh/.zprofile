# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# asdf (shims must come before Homebrew on PATH)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
