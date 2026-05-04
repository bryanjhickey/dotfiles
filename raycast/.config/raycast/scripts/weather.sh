#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Weather
# @raycast.mode fullOutput
# @raycast.refreshTime 30m
#
# Optional parameters:
# @raycast.icon 🌤
# @raycast.packageName System

# Documentation:
# @raycast.description Quick local forecast via wttr.in. Pass a city as argument override; defaults to current location.
# @raycast.author Bryan Hickey

# Defaults to current location (geo-IP). Replace with "Melbourne" or similar
# if you'd rather pin a city.
LOCATION="${1:-}"

# 0 = current + 3-day forecast in compact form
curl -fsSL "https://wttr.in/${LOCATION}?0&F" || echo "Couldn't reach wttr.in"
