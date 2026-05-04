-- Watch macOS dark/light mode and swap the desktop wallpaper accordingly.
-- Replaces the old scripts/dark-mode-notify Swift binary chain.

-- Wallpapers ship with macOS in /System/Library/Desktop Pictures/.
-- Swap these for any image paths you prefer.
local LIGHT_WALLPAPER = "/System/Library/Desktop Pictures/Solid Colors/Silver.png"
local DARK_WALLPAPER  = "/System/Library/Desktop Pictures/Solid Colors/Black.png"

local function isDarkMode()
  -- `defaults read -g AppleInterfaceStyle` returns "Dark" when dark mode is on,
  -- and exits with code 1 (no key) when light mode is on. We use stdout to detect.
  local out = hs.execute("defaults read -g AppleInterfaceStyle 2>/dev/null")
  return out and out:match("Dark") ~= nil
end

local function applyWallpaper()
  local path = isDarkMode() and DARK_WALLPAPER or LIGHT_WALLPAPER
  for _, screen in ipairs(hs.screen.allScreens()) do
    screen:desktopImageURL("file://" .. path)
  end
end

-- Apply once on load.
applyWallpaper()

-- Listen for the AppleInterfaceThemeChangedNotification system event.
-- hs.distributednotifications is the cleanest way to catch this on modern macOS.
darkModeWatcher = hs.distributednotifications.new(function(name, _, _)
  applyWallpaper()
end, "AppleInterfaceThemeChangedNotification")
darkModeWatcher:start()
