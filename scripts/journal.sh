#!/usr/bin/env bash
#
# journal.sh — the single home for plain-text journal capture.
#
# Subcommands:
#   note <text…>   Append a timestamped line:  "YYYY-MM-DD HH:MM — text"
#   stamp          Append a day header:        "## Weekday DD Month YYYY"
#
# Every caller is a thin adapter over this module:
#   - zsh note()                           → journal.sh note "$@"
#   - raycast "Journal Entry" script       → journal.sh note "$1"
#   - launchd dotfiles.daily-journal.plist → journal.sh stamp  (6am daily)

set -u

JOURNAL="$HOME/Documents/journal.md"

usage() {
  printf 'usage: %s <note <text…> | stamp>\n' "${0##*/}" >&2
  exit 64
}

[ "$#" -ge 1 ] || usage
cmd="$1"; shift

mkdir -p "$(dirname "$JOURNAL")"

case "$cmd" in
  note)
    [ "$#" -ge 1 ] || { printf 'journal note: needs text\n' >&2; exit 64; }
    printf '%s — %s\n' "$(date '+%Y-%m-%d %H:%M')" "$*" >> "$JOURNAL"
    printf '  appended to %s\n' "${JOURNAL/$HOME/~}"
    ;;
  stamp)
    printf '\n## %s\n\n' "$(date '+%A %d %B %Y')" >> "$JOURNAL"
    ;;
  *)
    usage
    ;;
esac
