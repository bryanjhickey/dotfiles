#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Lock Screen
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🔒
# @raycast.packageName System

# Documentation:
# @raycast.description Lock the screen immediately. Equivalent to ⌃⌘Q but reachable from Raycast.
# @raycast.author Bryan Hickey

pmset displaysleepnow
