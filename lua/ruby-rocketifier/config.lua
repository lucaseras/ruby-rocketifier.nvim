local M = {}

local commands = require("ruby-rocketifier.commands")

table.unpack = table.unpack or unpack -- 5.1 compatibility

M.default_opts = {
  keymaps = {
    to_rocket = false,
    to_colon = false,
    toggle = "<leader>l",
  }
}

M.user_opts = {}

M.add_keymap = function(args)
  -- Setting values to `false` in our keymaps makes it not set the keymap
  if args.lhs then
    vim.keymap.set(args.mode, args.lhs, args.rhs, args.opts)
  end
end

M.setup = function(user_opts)
  M.user_opts = user_opts and vim.tbl_deep_extend("force", M.default_opts, user_opts) or M.default_opts

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
  local keymap_opts = { silent = false, buffer = true }

  M.add_keymap({
    mode = "n",
    lhs = M.current_opts().keymaps.toggle,
    rhs = commands.toggle,
    opts = keymap_opts,
  })

  M.add_keymap({
    mode = "x",
    lhs = M.current_opts().keymaps.toggle,
    rhs = commands.visual_toggle,
    opts = keymap_opts,
  })

  M.add_keymap({
    mode = "n",
    lhs = M.current_opts().keymaps.to_rocket,
    rhs = commands.to_rocket,
    opts = keymap_opts,
  })

  M.add_keymap({
    mode = "x",
    lhs = M.current_opts().keymaps.to_rocket,
    rhs = commands.visual_to_rocket,
    opts = keymap_opts,
  })

  M.add_keymap({
    mode = "n",
    lhs = M.current_opts().keymaps.to_colon,
    rhs = commands.to_colon,
    opts = keymap_opts,
  })

  M.add_keymap({
    mode = "x",
    lhs = M.current_opts().keymaps.to_colon,
    rhs = commands.visual_to_colon,
    opts = keymap_opts,
  })
end

-- Get buffer options for the plugin, or the options set during setup
M.current_opts = function()
  -- If current opts has already been calculated, return early
  if M.current_opts_mem then return M.current_opts_mem end

  local buffer_opts = vim.b[0].ruby_rocketifier_buffer_opts

  local result = buffer_opts and buffer_opts or M.user_opts

  M.current_opts_mem = result

  return result
end

M.merge_opts_into_buffer_opts = function(opts)
  local current_opts = M.current_opts()

  opts = opts and vim.tbl_deep_extend("force", current_opts, opts) or current_opts

  vim.b[0].ruby_rocketifier_buffer_opts = opts
end

return M
