local M = {}

local utils = require('ruby-rocketifier.utils')
local actions = require('ruby-rocketifier.actions')

M.toggle = function()
  local row = utils.get_cursor_row()
  local result, action = actions.figure_out_action_from_line(row)

  if result then
    actions.apply_action(row, row, action)
  end
end

M.visual_toggle = function()
  vim.cmd([[execute "normal! \<esc>"]])
  local row_start, row_end = utils.get_visual_selection_range()
  local result, action = actions.figure_out_action_from_line(row_start)

  if result then
    actions.apply_action(row_start, row_end, action)
  end
end

return M
