--    __  _____  _____      __  ____  ____
--   /  |/  / / / / / | /| / / / __ \/ __/
--  / /|_/ / /_/_  _/ |/ |/ / / /_/ /\ \  
-- /_/  /_/____//_/ |__/|__/  \____/___/
--   
-- Advanced configuration for Hyprland

-- FUNCTIONS
require("functions")

-- MONITORS
require("monitors")
require("conf.monitor")

-- INPUT
require("input")

-- GESTURE
require("gestures")

-- AUTOSTART
require("conf.autostart")

-- COLORS
require("colors")

-- CONFIGURATION
require("conf.environment")
require("conf.window")
require("conf.decoration")
require("conf.layout")
require("conf.workspace")
require("conf.misc")
require("conf.keybinding")
require("conf.windowrule")
require("conf.animation")

-- CUSTOM
local f = io.open(os.getenv("HOME") .. "/.config/hypr/custom.lua", "r")
if f then
    f:close()
    require("custom")
end

-- HYPRMOD
require("hyprland-gui")
require("conf.superkey")

-- >>> MacShell (added by install.sh) >>>
-- Load the generated MacShell autostart and keybind module.
require("macshell")
-- Liquid Glass: blur behind the shell surfaces
hl.layer_rule({ name = "macdock",  match = { namespace = "macdock"  }, blur = true, ignore_alpha = 0.2,  no_anim = true })
hl.layer_rule({ name = "macspot",  match = { namespace = "macspot"  }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "macbarbg", match = { namespace = "macbarbg" }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "macshot",  match = { namespace = "macshot"  }, no_anim = true })
-- <<< MacShell <<<
