-- App focus/launch bindings under the Hyper key.
-- Tap Hyper+<letter> to focus the app (launching it if needed).
-- Add or remove rows freely; the table drives everything.

local apps = {
  b = "Google Chrome",
  t = "iTerm",
  e = "Visual Studio Code",
  o = "Obsidian",
  s = "Slack",      -- swap to "Microsoft Teams" if Teams is the primary work chat
  g = "Logos",      -- study
  z = "Zotero",     -- research / citations
  f = "Finder",
  p = "Preview",    -- PDF and image viewer
  w = "WhatsApp",
}

for key, name in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(name)
  end)
end

-- Hyper+0 — show all running apps' windows in mission-control style picker
hs.hotkey.bind(hyper, "0", hs.expose.new(nil, {showThumbnails = true}):toggleShow())
