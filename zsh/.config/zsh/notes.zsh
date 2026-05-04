# Quick-capture commands for Obsidian + plain-text notes.
#
# `note <text>`      Append a timestamped line to ~/Documents/journal.md.
#                    Stays out of any Obsidian vault by design — works even
#                    when no vault is configured.
#
# `obs <text>`       Same idea, but appends to today's daily note inside an
#                    Obsidian vault (set OBSIDIAN_VAULT below).
#
# `daily`            Open today's daily note in Obsidian. Requires the
#                    Daily Notes core plugin enabled in your active vault.

# Set this to your vault directory if you want `obs` to work.
# Empty by default so it fails loudly if invoked without a vault.
: ${OBSIDIAN_VAULT:=""}

note() {
  local entry="${*:?usage: note <text>}"
  local file="${HOME}/Documents/journal.md"
  mkdir -p "$(dirname "$file")"
  printf "%s — %s\n" "$(date '+%Y-%m-%d %H:%M')" "$entry" >> "$file"
  printf "  appended to %s\n" "${file/$HOME/~}"
}

obs() {
  local entry="${*:?usage: obs <text>}"
  if [[ -z "$OBSIDIAN_VAULT" ]]; then
    print -u2 "obs: set \$OBSIDIAN_VAULT to your vault path first (e.g. in ~/.zshenv)"
    return 1
  fi
  local today
  today="$(date '+%Y-%m-%d')"
  local file="${OBSIDIAN_VAULT}/Daily/${today}.md"
  mkdir -p "$(dirname "$file")"
  printf -- "- %s — %s\n" "$(date '+%H:%M')" "$entry" >> "$file"
  printf "  appended to %s\n" "${file/$HOME/~}"
}

daily() {
  open "obsidian://daily"
}
