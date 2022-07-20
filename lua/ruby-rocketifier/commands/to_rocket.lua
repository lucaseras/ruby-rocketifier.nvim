local M = {}

local utils = require('ruby-rocketifier.utils')
local actions = require('ruby-rocketifier.actions')

M.to_rocket = function()
  local row = utils.get_cursor_row()

  actions.apply_action(row, row, actions.colon_to_rocket)
end

M.visual_to_rocket = function()
  vim.cmd([[execute "normal! \<esc>"]])
  local row_start, row_end = utils.get_visual_selection_range()

  actions.apply_action(row_start, row_end, actions.colon_to_rocket)
end


return M
