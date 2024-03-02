local M = {
  colon_to_rocket = {},
  rocket_to_colon = {},
}

local key_valid_chars_regexp = "[%w:_?!]+"

-- Colon to rocket actions --

M.colon_to_rocket.transformation = function(key)
  return string.gsub(key, M.colon_to_rocket.pattern(), "'%1' => ")
end

M.colon_to_rocket.pattern = function()
  return "(".. key_valid_chars_regexp .. "): "
end

-- Rocket to colon actions --

M.rocket_to_colon.transformation = function(key)
  return string.gsub(key, M.rocket_to_colon.pattern(), '%1: ')
end

M.rocket_to_colon.pattern = function()
  return "[\'\"](".. key_valid_chars_regexp .. ")[\'\"] => "
end

return M
