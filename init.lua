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

require("user.plugins").setup(config)
require("user.options").setup()
require("user.autocommands").setup()
require("user.autopairs").setup()
require("user.lsp").setup()
require("user.keybindings").setup()

require("codecompanion").setup({
	--  extensions = {
	--   history = {
	--     enabled = true, -- defaults to true
	--     opts = {
	--       dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_chats.json",
	--     },
	--     keymaps = {
	--       open_history = "<leader>ch",
	--       delete_entry = "dd",
	--       select_entry = "<cr>",
	--     },
	--   }
	-- },
	display = {
		chat = {
			icons = {
				chat_context = "📎️", -- You can also apply an icon to the fold
			},
			fold_context = true,
		},
	},
	adapters = {
		http = {
			["llama.cpp"] = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "http://127.0.0.1:8080", -- replace with your llama.cpp instance
						-- api_key = "TERM",
						-- chat_url = "/v1/chat/completions",
					},
					handlers = {
						parse_message_meta = function(self, data)
							local extra = data.extra
							if extra and extra.reasoning_content then
								data.output.reasoning = { content = extra.reasoning_content }
								if data.output.content == "" then
									data.output.content = nil
								end
							end
							return data
						end,
					},
				})
			end,
		},
	},
	interactions = {
		chat = {
			opts = {
				completion_provider = "cmp",
				---Decorate the user message before it's sent to the LLM
				---@param message string
				---@param adapter CodeCompanion.Adapter
				---@param context table
				---@return string
				prompt_decorator = function(message, adapter, context)
					return string.format([[<prompt>%s</prompt>]], message)
				end,
			},
			adapter = "llama.cpp",
		},
	},
})
-- require('').install({ 'rust', 'javascript', 'zig' , 'typescript', 'lua','c', 'ruby', 'go', 'java', 'html', 'css', 'json', 'yaml', 'bash', 'markdown', 'markdown_inline', 'elixir', 'gleam' })
