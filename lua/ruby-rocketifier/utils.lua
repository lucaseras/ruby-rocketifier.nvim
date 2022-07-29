local M = {}

M.get_cursor_position = function()
  return vim.api.nvim_win_get_cursor(0)
end

M.get_cursor_row = function()
  return M.get_cursor_position()[1]
end

M.set_lines = function(start, stop, lines)
  vim.api.nvim_buf_set_lines(0, start - 1, stop, false, lines)
end


M.get_lines = function(start, stop)
  return vim.api.nvim_buf_get_lines(0, start - 1, stop, false)
end

M.get_line = function(row)
  return vim.api.nvim_buf_get_lines(0, row - 1, row, false)
end

M.get_visual_selection_range = function()
  vim.cmd([[execute "normal! \<esc>"]])
  local _, start_row, _, _ = table.unpack(vim.fn.getpos("'<"))
  local _, end_row, _, _ = table.unpack(vim.fn.getpos("'>"))
  if start_row < end_row then
    return start_row, end_row
  else
    return end_row, start_row
  end
end

M.run_visual_command = function(command)
  local row_start, row_end = M.get_visual_selection_range()

  command(row_start, row_end)
end

return M
