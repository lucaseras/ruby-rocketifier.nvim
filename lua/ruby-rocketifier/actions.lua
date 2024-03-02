local M = {}

local utils = require('ruby-rocketifier.utils')
local patterns = require('ruby-rocketifier.patterns')

-- Given a line, figure out what action should be done
M.figure_out_action_from_line = function(row)
  local line = utils.get_lines(row, row)[1]

  local result_action
  local current_match

  for _, action in pairs(patterns) do
    local pattern_match = string.find(line, action.pattern())

    if (current_match and pattern_match and pattern_match < current_match) or
      (not current_match and pattern_match)
    then
      result_action = action
      current_match = pattern_match
    end
  end

  if not result_action then
    return false, nil
  end

  return true, result_action
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

return M
