local M = {}

-- Using separate files just for cleanliness
local toggle_commands = require('ruby-rocketifier.commands.toggle')
local to_rocket_commands = require('ruby-rocketifier.commands.to_rocket')
local to_colon_commands = require('ruby-rocketifier.commands.to_colon')

M.toggle = toggle_commands.toggle
M.visual_toggle = toggle_commands.visual_toggle
M.to_rocket = to_rocket_commands.to_rocket
M.visual_to_rocket = to_rocket_commands.visual_to_rocket
M.to_colon = to_colon_commands.to_colon
M.visual_to_colon = to_colon_commands.visual_to_colon

return M
