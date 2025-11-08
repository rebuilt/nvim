-- https://github.com/onosendi/dotfiles/blob/master/common/.config/nvim/lua/config/lsp/global.lua
local M = {}

M.setup = function()
	-- vim.lsp.config.lua = {
	-- 	cmd = { "lua-language-server" },
	-- 	filetypes = { "lua" },
	-- 	root_markers = {
	-- 		".luarc.json",
	-- 		".luarc.jsonc",
	-- 		".luacheckrc",
	-- 		".stylua.toml",
	-- 		"stylua.toml",
	-- 		"selene.toml",
	-- 		"selene.yml",
	-- 		".git",
	-- 	},
	-- 	settings = {
	-- 		Lua = {
	-- 			runtime = {
	-- 				version = "LuaJIT",
	-- 				path = vim.split(package.path, ";"),
	-- 			},
	-- 			diagnostics = {
	-- 				globals = { "vim" },
	-- 			},
	-- 			workspace = {
	-- 				library = vim.api.nvim_get_runtime_file("", true),
	-- 			},
	-- 			telemetry = {
	-- 				enable = false,
	-- 			},
	-- 		},
	-- 	},
	-- }

	vim.lsp.config.clangd = {
		init_options = {

			-- im using this standard since i want the compiler to

			-- know about true, false, etc - see

			-- https://xnacly.me/posts/2025/clangd-lsp/

			fallbackFlags = { "--std=c23" },
		},
	}

	vim.lsp.config.c = {
		init_options = {

			-- im using this standard since i want the compiler to

			-- know about true, false, etc - see

			-- https://xnacly.me/posts/2025/clangd-lsp/

			fallbackFlags = { "--std=c23" },
		},
	}
	vim.lsp.enable({
		"rust",
		"javascript",
		"zig",
		"typescript",
		"lua",
		"c",
		-- "ruby",
		"ruby-lsp",
		"go",
		"java",
		"html",
		"css",
		"json",
		"yaml",
		"bash",
		"markdown",
		"markdown_inline",
		"elixir",
		"gleam",
	})

	-- require('nvim-treesitter').install({ 'rust', 'javascript', 'zig' , 'typescript', 'lua','c', 'ruby', 'go', 'java', 'html', 'css', 'json', 'yaml', 'bash', 'markdown', 'markdown_inline', 'elixir', 'gleam' })
end

return M
