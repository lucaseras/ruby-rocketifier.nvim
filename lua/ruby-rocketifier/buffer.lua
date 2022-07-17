local M = {}

M.get_cursor_position = function()
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  return cursor_position[1], cursor_position[2] + 1
end

M.set_cursor_position = function(row, column)
  vim.api.nvim_win_set_cursor(0, {row, column})
end

return M
