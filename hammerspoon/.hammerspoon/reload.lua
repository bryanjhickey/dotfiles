-- Auto-reload Hammerspoon config whenever a .lua file in ~/.hammerspoon/ changes.
-- Saves a manual "Reload Config" trip to the menu bar after every edit.

local function reload(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end

configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload)
configWatcher:start()
