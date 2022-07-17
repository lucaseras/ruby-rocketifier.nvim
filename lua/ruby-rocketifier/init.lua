local M = {}

local config = require("ruby-rocketifier.config")

M.setup = function(opts)
  config.setup(opts)
end

return M
