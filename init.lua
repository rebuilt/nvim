--[[
    `:help lua-guide`
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

    keymap "<space>sh" to [s]earch the [h]elp documentation,

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
local config = { enable_copilot = true }

require("user.options").setup()
require("user.autocommands").setup()
require("user.plugins").setup(config)
require("user.autopairs").setup()
require("user.lsp").setup()
require("user.keybindings").setup()
