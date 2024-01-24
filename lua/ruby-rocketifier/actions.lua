local M = {
  colon_to_rocket = {},
  rocket_to_colon = {},
}

local utils = require('ruby-rocketifier.utils')

-- Given a line, figure out what action should be done
M.figure_out_action_from_line = function(row)
  local line = utils.get_lines(row, row)[1]

  local colon_match = string.find(line, M.colon_to_rocket.pattern())
  local rocket_match = string.find(line, M.rocket_to_colon.pattern())

  local action
  if colon_match ~= nil then
    action = M.colon_to_rocket
  elseif rocket_match ~= nil then
    action = M.rocket_to_colon
  else
    return false, nil
  end

  return true, action
end

local function transform_line(line, action, index)

  local start, stop = string.find(line, action.pattern(), index)

  if start == nil then return line end

  local key = string.sub(line, start, stop)
  local new_key = action.transformation(key)

  local new_line = string.gsub(line, key, new_key)

  return transform_line(new_line, action, stop)
end

-- Given two line numbers and an action, apply the action to those lines
M.apply_action = function(row_start, row_end, action)
  local lines = utils.get_lines(row_start, row_end)

  local new_lines = {}
  for _, current_line in pairs(lines) do
    local new_line = transform_line(current_line, action, 1)

    table.insert(new_lines, new_line)
  end

  utils.set_lines(row_start, row_end, new_lines)
end

local key_valid_chars_regexp = "[%w:_?!]+"

-- Colon to rocket actions --

M.colon_to_rocket.transformation = function(key)
  return string.gsub(key, M.colon_to_rocket.pattern(), "'%1' =>")
end

M.colon_to_rocket.pattern = function()
  return "(".. key_valid_chars_regexp .. "):"
end

-- Rocket to colon actions --

M.rocket_to_colon.transformation = function(key)
  return string.gsub(key, M.rocket_to_colon.pattern(), '%1:')
end

M.rocket_to_colon.pattern = function()
  return "[\'\"](".. key_valid_chars_regexp .. ")[\'\"] =>"
end

return M
