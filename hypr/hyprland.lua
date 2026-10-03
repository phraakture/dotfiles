-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- User Configuration goeas here.
-- Adding keybinding are simple, refer to the wiki and add it here!
-- Duplicated keybinding will always respect the last last added, therefore please override keybindings as you wish.
--- use "require()" to load other lua files, for example:
-- require("keybindings") --- this will load "keybindings.lua"

-- Monitor: wildcard -> preferred, auto, 1  (from backup monitors.conf: monitor = ,preferred, auto, 1)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

local MOD = "SUPER"

-- Custom workspace bindings
hl.bind(MOD .. " + U", hl.dsp.focus({workspace = 1})) -- MOD + U → workspace 1
hl.bind(MOD .. " + I", hl.dsp.focus({workspace = 2})) -- MOD + I → workspace 2
hl.bind(MOD .. " + O", hl.dsp.focus({workspace = 3})) -- MOD + O → workspace 3
hl.bind(MOD .. " + P", hl.dsp.focus({workspace = 4})) -- MOD + P → workspace 4
hl.bind(MOD .. " + Y", hl.dsp.exec_cmd("obsidian")) -- MOD + Y → Obsidian (bare)

-- Global cursor speed +25% (sensitivity 0.25) + flat accel + natural scroll for touchpad
hl.config({
  input = {
    sensitivity = 0.25,
    accel_profile = "flat",
    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
      -- optional: scroll_factor = 1.0
    }
  },
  -- Bibata's hyprcursor shapes never switch (stuck on arrow); use XCursor instead
  cursor = {
    enable_hyprcursor = false,
  },
})

-- Ignore apps asking to open maximized (kitty 0.49+ does this; breaks tiling)
-- Hyprland's stock config has this rule, HyDE's Lua config doesn't
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Resize active window with SUPER + SHIFT + arrows (hold to repeat, 30px steps)
local RESIZE = MOD .. " + SHIFT"
hl.bind(RESIZE .. " + LEFT",  hl.dsp.window.resize({x = -30, y = 0,   relative = true}), {description = "[Window Management|Resize Active Window] resize left (arrows)",  repeating = true})
hl.bind(RESIZE .. " + RIGHT", hl.dsp.window.resize({x = 30,  y = 0,   relative = true}), {description = "[Window Management|Resize Active Window] resize right (arrows)", repeating = true})
hl.bind(RESIZE .. " + UP",    hl.dsp.window.resize({x = 0,   y = -30, relative = true}), {description = "[Window Management|Resize Active Window] resize up (arrows)",    repeating = true})
hl.bind(RESIZE .. " + DOWN",  hl.dsp.window.resize({x = 0,   y = 30,  relative = true}), {description = "[Window Management|Resize Active Window] resize down (arrows)",  repeating = true})

-- Toggle waybar (HyDE's ALT_R + CONTROL_R bind is broken under the Lua parser)
hl.unbind(hyde.binds.normalize("ALT_R + CONTROL_R")) -- remove the dead bind
hl.bind(MOD .. " + SHIFT + B", hl.dsp.exec_cmd(hyde.sh.waybar("--hide")),
  {description = "[Window Management] toggle waybar"})
