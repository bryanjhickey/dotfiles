-- Hammerspoon entry point.
-- Loads modules in order; each returns nothing (side-effecting only).
-- Hyper key (⌃⌥⇧⌘) is sent by Karabiner-Elements when Caps Lock is held.

-- Disable animations — Hammerspoon's window moves are more responsive without them.
hs.window.animationDuration = 0

-- Define the Hyper modifier set used everywhere else.
hyper = {"ctrl", "alt", "shift", "cmd"}

require("windows")
require("apps")
require("darkmode")
require("reload")

-- Confirmation banner so we know the config loaded.
hs.alert.show("Hammerspoon: config loaded", 1)
