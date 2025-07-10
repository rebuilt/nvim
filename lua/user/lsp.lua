local M = {}

M.setup = function()
	nvim_lsp = require("lspconfig")
	nvim_lsp.gleam.setup({})

	-- PLUGIN / neovim native lsp / ruby / solargraph
	require("lspconfig").solargraph.setup({
		-- cmd = { os.getenv( "HOME" ) .. "/.rvm/shims/solargraph", 'stdio' },
		cmd = { os.getenv("HOME") .. "/.asdf/shims/solargraph", "stdio" },
		root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
		settings = {
			solargraph = {
				autoformat = true,
				formatting = true,
				completion = true,
				diagnostic = true,
				folding = true,
				references = true,
				rename = true,
				symbols = true,
			},
		},
	})
end

return M
