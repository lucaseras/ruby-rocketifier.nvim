local M = {}

local transformations = require("ruby-rocketifier.transformations")

M.default_opts = {
  keymaps = {
    to_rocket = '<leader>l',
    to_colon = false,
    toggle = "crh",
  }
}

M.user_opts = {}

M.add_keymap = function(args)
  if args.lhs then
    vim.keymap.set(args.mode, args.lhs, args.rhs, args.opts)
  end
end

M.setup = function(user_opts)
  user_opts = user_opts and vim.tbl_deep_extend("force", M.default_opts, user_opts) or M.default_opts
  M.user_opts = user_opts

  M.setup_triggers()
end

M.setup_triggers = function()
  -- This plugin only works with Ruby files
  local group = vim.api.nvim_create_augroup("rubyRocketifierSetup", {})
  vim.api.nvim_create_autocmd({"BufEnter"}, {
    pattern = "*.rb",
    callback = M.buffer_setup,
    group = group,
  })
end

M.buffer_setup = function(buffer_opts)
  M.merge_opts_into_buffer_opts(buffer_opts)

  M.add_keymap({
    mode = "n",
    lhs = M.get_current_opts().keymaps.to_rocket,
    rhs = transformations.transform_to_rocket,
    opts = { silent = false, buffer = true }
  })

  M.add_keymap({
    mode = "v",
    lhs = M.get_current_opts().keymaps.to_rocket,
    rhs = "<Esc><Cmd>lua require('ruby-rocketifier.transformations').visual_transform_to_rocket()<CR>",
    opts = { silent = false, buffer = true }
  })
end

-- Get buffer options for the plugin, or the options set during setup
M.get_current_opts = function()
  local buffer_opts = vim.b[0].ruby_rocketifier_buffer_opts

  return buffer_opts and buffer_opts or M.user_opts
end

M.merge_opts_into_buffer_opts = function(opts)
  local current_opts = M.get_current_opts()

  opts = opts and vim.tbl_deep_extend("force", current_opts, opts) or current_opts

  vim.b[0].ruby_rocketifier_buffer_opts = opts
end

return M
