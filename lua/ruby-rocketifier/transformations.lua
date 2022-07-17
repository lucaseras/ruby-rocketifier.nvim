local M = {}

local buffer = require("ruby-rocketifier.buffer")
local utils = require('ruby-rocketifier.utils')

M.transform_to_rocket = function()
  local row = utils.get_cursor_row()

  M.transform_key_in_lines(row, row)
end

M.visual_transform_to_rocket = function()
  local row_start, row_end = utils.get_visual_selection_range()

  M.transform_key_in_lines(row_start, row_end)
  buffer.set_cursor_position(row_start, 0)
end

M.get_lines = function(start, stop)
  return vim.api.nvim_buf_get_lines(0, start - 1, stop, false)
end

M.set_lines = function(start, stop, lines)
  vim.api.nvim_buf_set_lines(0, start - 1, stop, false, lines)
end

M.get_visual_selection_range = function()
  local start, stop = vim.api.nvim_buf_get_mark(0, "<")[1], vim.api.nvim_buf_get_mark(0, ">")[1]

  return start, stop
end

-- TODO: use treesitter for this
-- TODO: make `new_key` logic into a sort of regexp substitution logic
-- TODO: pass in find_pattern and substitution_pattern, so that we can use this same function for the other direction
M.transform_key_in_lines = function(row_start, row_end)
  local lines = M.get_lines(row_start, row_end)

  local new_lines = {}
  for _, current_line in pairs(lines) do
    local start, stop = string.find(current_line, "%a+:")

    -- proceed to next line if could not find pattern
    if start == nil then
      table.insert(new_lines, current_line)
      goto continue
    end

    local key = string.sub(current_line, start, stop)
    local new_key = "'" .. string.sub(current_line, start, stop - 1) .. "'" .. " =>"

    local new_line = string.gsub(current_line, key, new_key)

    table.insert(new_lines, new_line)

    ::continue::
  end

  M.set_lines(row_start, row_end, new_lines)
end

return M
