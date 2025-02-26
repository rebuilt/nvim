local M = {}
M.setup = function()
	-- [[ Basic Keymaps ]]
	--  See `:help vim.keymap.set()`

	-- Clear highlights on search when pressing <Esc> in normal mode
	--  See `:help hlsearch`
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- Diagnostic keymaps
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
	-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
	-- is not what someone will guess without a bit more experience.
	--
	-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
	-- or just use <C-\><C-n> to exit terminal mode
	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

	-- TIP: Disable arrow keys in normal mode
	-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
	-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
	-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
	-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

	-- Keybinds to make split navigation easier.
	--  Use CTRL+<hjkl> to switch between windows
	--
	--  See `:help wincmd` for a list of all window commands
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- The line beneath this is called `modeline`. See `:help modeline`
	-- vim: ts=2 sts=2 sw=2 et
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	local npairs = require("nvim-autopairs")
	npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
	npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
	npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
	vim.keymap.set("n", "<leader>sw", builtin.live_grep, { desc = "Telescope live grep" })
	vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })

	vim.api.nvim_set_keymap("n", "<A-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<A-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<F12>", ":set relativenumber!<CR>", { noremap = true, silent = true })
	-- Hitting escape also clears spelling and search highlights
	vim.api.nvim_set_keymap(
		"n",
		"<ESC>",
		":nohls |:set norelativenumber | :setlocal nospell<ESC>",
		{ noremap = true, silent = true }
	)

	-- When you search, center the result and open any folds
	vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true })

	-- When you search backwards, center the result and open any folds
	vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true })

	-- Keep the cursor in the same place when joining lines
	vim.api.nvim_set_keymap("n", "J", "mzJ`z", { noremap = true, silent = true })

	vim.api.nvim_set_keymap("n", "<leader>y", '"+y', { noremap = true, silent = true })

	-- If a movement is greater than 15 lines, add it to the jump list
	vim.api.nvim_set_keymap(
		"n",
		"k",
		[[(v:count > 50 ? "m'" . v:count : "") . 'k']],
		{ noremap = true, silent = true, expr = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"j",
		[[(v:count > 50 ? "m'" . v:count : "") . 'j']],
		{ noremap = true, silent = true, expr = true }
	)

	-- Yank from the current position to the end of the line
	vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>c", "<cmd>bd<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>:e ~/.config/nvim/init.lua<cr>", { noremap = true, silent = true })

	nvim_lsp = require("lspconfig")

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
