local M = {}

local utils = require('ruby-rocketifier.utils')
local actions = require('ruby-rocketifier.actions')

M.to_colon = function()
  local row = utils.get_cursor_row()

  actions.apply_action(row, row, actions.rocket_to_colon)
end

M.visual_to_colon = function()
  vim.cmd([[execute "normal! \<esc>"]])
  local row_start, row_end = utils.get_visual_selection_range()

  actions.apply_action(row_start, row_end, actions.rocket_to_colon)
end

return M
