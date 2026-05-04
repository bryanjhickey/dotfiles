-- Window management bindings under the Hyper key.
-- All hotkeys: Hyper+<key>. Hyper is configured in init.lua.

-- Resize the focused window to a fraction of the screen frame.
-- frac = {x, y, w, h} as fractions of the screen (0..1).
local function resize(frac)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:screen():frame()
    win:setFrame({
      x = f.x + f.w * frac[1],
      y = f.y + f.h * frac[2],
      w = f.w * frac[3],
      h = f.h * frac[4],
    })
  end
end

-- Halves
hs.hotkey.bind(hyper, "h", resize({0,   0,   0.5, 1  }))    -- left half
hs.hotkey.bind(hyper, "l", resize({0.5, 0,   0.5, 1  }))    -- right half
hs.hotkey.bind(hyper, "k", resize({0,   0,   1,   0.5}))    -- top half
hs.hotkey.bind(hyper, "j", resize({0,   0.5, 1,   0.5}))    -- bottom half

-- Quarters (corners): u/i/n/m → top-left/top-right/bottom-left/bottom-right
hs.hotkey.bind(hyper, "u", resize({0,   0,   0.5, 0.5}))
hs.hotkey.bind(hyper, "i", resize({0.5, 0,   0.5, 0.5}))
hs.hotkey.bind(hyper, "n", resize({0,   0.5, 0.5, 0.5}))
hs.hotkey.bind(hyper, ",", resize({0.5, 0.5, 0.5, 0.5}))

-- Maximize
hs.hotkey.bind(hyper, "m", resize({0, 0, 1, 1}))

-- Centre at 70% size — the "I want to read this without the menubar in my face" preset
hs.hotkey.bind(hyper, "c", resize({0.15, 0.15, 0.7, 0.7}))

-- Move focused window to next monitor (cycles)
hs.hotkey.bind(hyper, "right", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():next(), false, true)
end)
hs.hotkey.bind(hyper, "left", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  win:moveToScreen(win:screen():previous(), false, true)
end)
