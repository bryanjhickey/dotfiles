#!/usr/bin/env bash
#
# inbox-to-calibre.sh
#
# Scan one or more inbox directories for ebook-shaped files and import them
# into Calibre's library, removing the originals on success.
#
# Triggered by macos/Library/LaunchAgents/dotfiles.calibre-import.plist on
# changes to ~/Downloads and ~/Documents/Digital Editions/. Can also be
# invoked manually:
#
#   ./scripts/inbox-to-calibre.sh ~/Downloads "$HOME/Documents/Digital Editions"
#
# Caveats
# -------
# - If Calibre is currently RUNNING, the library is locked and `calibredb add`
#   will fail. The script logs and bails — re-run after closing Calibre, or
#   wait for the next file-add to retrigger.
# - Files matched but failed are left in place; reruns are safe (idempotent).

set -u
set -o pipefail

CALIBRE_LIBRARY="${CALIBRE_LIBRARY:-$HOME/Calibre Library}"
CALIBREDB="/Applications/calibre.app/Contents/MacOS/calibredb"
LOG_FILE="${TMPDIR:-/tmp}/dotfiles.calibre-import.log"

EXT_RE='.*\.(epub|pdf|mobi|azw3|azw|cbr|cbz|fb2|lrf|chm|rtf|odt|docx)$'

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG_FILE" >&2; }

if [ "$#" -eq 0 ]; then
  log "usage: $0 <inbox-dir> [<inbox-dir> ...]"
  exit 64
fi

if [ ! -x "$CALIBREDB" ]; then
  log "calibredb not found at $CALIBREDB — install Calibre first"
  exit 1
fi

if [ ! -d "$CALIBRE_LIBRARY" ]; then
  log "Calibre library not found at $CALIBRE_LIBRARY — set CALIBRE_LIBRARY env"
  exit 1
fi

# If Calibre is running, calibredb can't grab the library lock. Bail early
# so we don't pile up failures in the log on every WatchPaths fire.
if pgrep -qf '/Applications/calibre.app/Contents/MacOS/calibre$'; then
  log "Calibre is running — skipping import (will retry on next file add)"
  exit 0
fi

added=0
skipped=0
for inbox in "$@"; do
  if [ ! -d "$inbox" ]; then
    log "skip: $inbox does not exist"
    continue
  fi

  while IFS= read -r -d '' file; do
    log "importing: $file"
    if "$CALIBREDB" add --with-library "$CALIBRE_LIBRARY" --duplicates "$file" >>"$LOG_FILE" 2>&1; then
      rm -f "$file"
      added=$((added + 1))
    else
      log "failed: $file (left in place for retry)"
      skipped=$((skipped + 1))
    fi
  done < <(find "$inbox" -maxdepth 2 -type f -iregex "$EXT_RE" -print0)
done

if [ "$added" -gt 0 ]; then
  /usr/bin/osascript -e "display notification \"$added imported, $skipped skipped\" with title \"Calibre\""
  log "done: $added added, $skipped skipped"
fi
