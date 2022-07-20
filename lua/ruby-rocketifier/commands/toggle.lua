local M = {}

local utils = require('ruby-rocketifier.utils')
local actions = require('ruby-rocketifier.actions')

M.toggle = function()
  local row = utils.get_cursor_row()
  local action = actions.figure_out_action_from_line(row)

  actions.apply_action(row, row, action)
end

M.visual_toggle = function()
  vim.cmd([[execute "normal! \<esc>"]])
  local row_start, row_end = utils.get_visual_selection_range()
  local action = actions.figure_out_action_from_line(row_start)

  actions.apply_action(row_start, row_end, action)
end

return M
