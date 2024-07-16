local wezterm = require("wezterm")
local config = wezterm.config_builder()

if string.find(wezterm.target_triple, "windows") then
    config.default_prog = { 'powershell.exe' }
end


config.font = wezterm.font("Mononoki Nerd Font")

config.enable_tab_bar = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 8
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}


local tokyo_night = {
	foreground = "#a9b1d6",
	background = "#1a1b26",
	cursor_bg = "#32344a",
	cursor_border = "#32344a",
	cursor_fg = "#787c99",
	selection_bg = "#32344a",
	selection_fg = "#787c99",
	ansi = { "#32344a", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#ad8ee6", "#449dab", "#787c99" },
	brights = { "#444b6a", "#ff7a93", "#b9f27c", "#ff9e64", "#7da6ff", "#bb9af7", "#0db9d7", "#acb0d0" },
}

config.colors = tokyo_night
config.colors.tab_bar = {
    inactive_tab_edge = tokyo_night.background,
    background = tokyo_night.background,
    active_tab = {
        bg_color = tokyo_night.background,
        fg_color = tokyo_night.foreground,
    },
    inactive_tab = {
        bg_color = tokyo_night.background,
        fg_color = tokyo_night.ansi[8],
    },
    inactive_tab_hover = {
        bg_color = tokyo_night.background,
        fg_color = tokyo_night.brights[8],
    },
    new_tab = {
        bg_color = tokyo_night.background,
        fg_color = tokyo_night.ansi[8],
    },    
    new_tab_hover = {
        bg_color = tokyo_night.background,
        fg_color = tokyo_night.brights[8],
    },
}

config.window_frame  = {
    active_titlebar_bg  = tokyo_night.background,
    inactive_titlebar_bg  = tokyo_night.background,
}

return config