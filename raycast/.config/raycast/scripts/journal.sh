#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Journal Entry
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "thought" }
#
# Optional parameters:
# @raycast.icon ✍️
# @raycast.packageName Notes

# Documentation:
# @raycast.description Append a timestamped line to ~/Documents/journal.md
# @raycast.author Bryan Hickey

exec "$HOME/code/dotfiles/scripts/journal.sh" note "$1"
