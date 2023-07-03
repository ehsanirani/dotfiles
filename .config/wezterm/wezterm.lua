-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = 'Dracula+'
--config.color_scheme = 'duskfox'
--config.color_scheme = 'Dracula+'

--config.color_scheme = 'Epiphany (terminal.sexy)'
--config.color_scheme = 'Galaxy'
--config.color_scheme = 'Glacier'
--config.color_scheme = 'Gogh (Gogh)'
--config.color_scheme = 'Google Dark (Gogh)'
--config.color_scheme = 'Dracula'
--config.color_scheme = 'Goey (Gogh)'




config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config
