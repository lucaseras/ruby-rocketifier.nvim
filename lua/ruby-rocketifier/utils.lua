local M = {}

M.get_cursor_position = function()
  return vim.api.nvim_win_get_cursor(0)
end

M.get_cursor_row = function()
  return M.get_cursor_position()[1]
end

M.get_visual_selection_range = function()
  local _, start_row, _, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, _, _ = unpack(vim.fn.getpos("'>"))
  if start_row < end_row then
    return start_row, end_row
  else
    return end_row, start_row
  end
end


return M
