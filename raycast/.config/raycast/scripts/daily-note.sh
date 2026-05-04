#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Daily Note
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 📓
# @raycast.packageName Obsidian

# Documentation:
# @raycast.description Open today's daily note in Obsidian. Requires the "Daily Notes" core plugin to be enabled in your vault.
# @raycast.author Bryan Hickey
# @raycast.authorURL https://github.com/bryanjhickey

# Trigger Obsidian's "Open today's daily note" command via URL scheme.
# `vault` is omitted so Obsidian uses the last-active vault — set it explicitly
# (e.g. ?vault=Notes) if you want to pin to one.
open "obsidian://daily"
