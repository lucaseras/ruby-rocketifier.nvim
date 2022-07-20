local M = {
  colon_to_rocket = {},
  rocket_to_colon = {},
}

local utils = require('ruby-rocketifier.utils')

-- Given a line, figure out what action should be done
M.figure_out_action_from_line = function(row)
  local line = utils.get_lines(row, row)[1]

  local colon_match = string.find(line, M.colon_to_rocket.pattern())

  if colon_match ~= nil then
    return M.colon_to_rocket
  else
    return M.rocket_to_colon
  end
end

-- Given two line numbers and an action, apply the action to those lines
M.apply_action = function(row_start, row_end, action)
  local lines = utils.get_lines(row_start, row_end)

  local new_lines = {}
  for _, current_line in pairs(lines) do
    local start, stop = string.find(current_line, action.pattern())

    -- proceed to next line if could not find pattern
    if start == nil then
      table.insert(new_lines, current_line)
      goto continue
    end

    local key = string.sub(current_line, start, stop)
    local new_key = action.transformation(key)

    local new_line = string.gsub(current_line, key, new_key)

    table.insert(new_lines, new_line)

    ::continue::
  end

  utils.set_lines(row_start, row_end, new_lines)
end

-- Colon to rocket actions --

M.colon_to_rocket.transformation = function(key)
  return string.gsub(key, M.colon_to_rocket.pattern(), "'%1' => ")
end

M.colon_to_rocket.pattern = function()
  return "(%S+): "
end

-- Rocket to colon actions --

M.rocket_to_colon.transformation = function(key)
  -- return string.sub(key, 2, #key - 4) .. ":"
  return string.gsub(key, M.rocket_to_colon.pattern(), '%1: ')
end

M.rocket_to_colon.pattern = function()
  return "'(%S+)' => "
end

return M
