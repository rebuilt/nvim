local M = {}
M.setup = function(config)
	-- This is a simple example of how to use the `lazy.nvim` plugin manager.
	-- It is recommended to use this as a starting point for your own configuration.
	-- You can find more information about `lazy.nvim` at
	-- [[ Install `lazy.nvim` plugin manager ]]
	--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			error("Error cloning lazy.nvim:\n" .. out)
		end
	end ---@diagnostic disable-next-line: undefined-field
	vim.opt.rtp:prepend(lazypath)

	-- [[ Configure and install plugins ]]
	--
	--  To check the current status of your plugins, run
	--    :Lazy
	--
	--  You can press `?` in this menu for help. Use `:q` to close the window
	--
	--  To update plugins you can run
	--    :Lazy update
	--
	-- NOTE: Here is where you install your plugins.
	require("lazy").setup({
		-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
		{ -- Highlight, edit, and navigate code
			-- cargo install --locked tree-sitter-cli

			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			branch = 'main',
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			config = function()
			end,
		},

		"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
		"tpope/vim-repeat",
		"tpope/vim-fugitive",
		"kevinhwang91/nvim-bqf",
		{
			"nvim-focus/focus.nvim",
			config = function()
				require("focus").setup()
			end,
		},

		-- NOTE: Plugins can also be added by using a table,
		-- with the first argument being the link and the following
		-- keys can be used to configure plugin behavior/loading/etc.
		--
		-- Use `opts = {}` to force a plugin to be loaded.
		--

		-- Here is a more advanced example where we pass configuration
		-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
		--    require('gitsigns').setup({ ... })
		--
		-- See `:help gitsigns` to understand what the configuration keys do
		--  { -- Adds git related signs to the gutter, as well as utilities for managing changes
		-- 	"lewis6991/gitsigns.nvim",
		-- },
		-- {"airblade/vim-gitgutter"},
		{ 'echasnovski/mini.nvim', 
		version = false,
			config = function()
				require('mini.diff').setup()
			end},
		{
			"brenoprata10/nvim-highlight-colors",
			config = function()
				-- Ensure termguicolors is enabled if not already
				vim.opt.termguicolors = true

				require("nvim-highlight-colors").setup({})
			end,
		},
		{
			"nvim-tree/nvim-tree.lua",
			config = function()
				local function my_on_attach(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
					vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
					vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open: Horizontal Split"))
				end

				vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

				require("nvim-tree").setup({
					experimental = {},
					auto_reload_on_write = false,
					disable_netrw = false,
					hijack_cursor = false,
					hijack_netrw = true,
					hijack_unnamed_buffer_when_opening = false,
					sort = {
						sorter = "name",
						folders_first = true,
						files_first = false,
					},
					root_dirs = {},
					prefer_startup_root = false,
					sync_root_with_cwd = true,
					reload_on_bufenter = false,
					respect_buf_cwd = false,
					select_prompts = false,
					view = {
						adaptive_size = false,
						centralize_selection = true,
						width = 30,
						cursorline = true,
						debounce_delay = 15,
						side = "left",
						preserve_window_proportions = false,
						number = false,
						relativenumber = false,
						signcolumn = "yes",
						float = {
							enable = false,
							quit_on_focus_loss = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 30,
								height = 30,
								row = 1,
								col = 1,
							},
						},
					},
					hijack_directories = {
						enable = false,
						auto_open = true,
					},
					update_focused_file = {
						enable = true,
						update_root = {
							enable = true,
							ignore_list = {},
						},
						exclude = false,
					},
					actions = {
						use_system_clipboard = true,
						change_dir = {
							enable = true,
							global = false,
							restrict_above_cwd = false,
						},
						expand_all = {
							max_folder_discovery = 300,
							exclude = {},
						},
						file_popup = {
							open_win_config = {
								col = 1,
								row = 1,
								relative = "cursor",
								border = "shadow",
								style = "minimal",
							},
						},
						open_file = {
							quit_on_open = false,
							eject = true,
							resize_window = false,
							window_picker = {
								enable = true,
								picker = "default",
								chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
								exclude = {
									filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
									buftype = { "nofile", "terminal", "help" },
								},
							},
						},
						remove_file = {
							close_window = true,
						},
					},
					tab = {
						sync = {
							open = false,
							close = false,
							ignore = {},
						},
					},
					notify = {
						threshold = vim.log.levels.INFO,
						absolute_path = true,
					},
					ui = {
						confirm = {
							remove = true,
							trash = true,
							default_yes = false,
						},
					},
					modified = {
						enable = false,
						show_on_dirs = true,
						show_on_open_dirs = true,
					},
					on_attach = my_on_attach,
				})
			end,
		},
		-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
		--
		-- This is often very useful to both group configuration, as well as handle
		-- lazy loading plugins that don't need to be loaded immediately at startup.
		--
		-- For example, in the following configuration, we use:
		--  event = 'VimEnter'
		--
		-- which loads which-key before all the UI elements are loaded. Events can be
		-- normal autocommands events (`:help autocmd-events`).
		--
		-- Then, because we use the `opts` key (recommended), the configuration runs
		-- after the plugin has been loaded as `require(MODULE).setup(opts)`.
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},

		{
			"mg979/vim-visual-multi",
			config = function()
				vim.cmd([[
			let g:VM_maps = {}
			let g:VM_mouse_mappings = 1
			]])
			end,
		},
		{ "dhruvasagar/vim-table-mode" },
		{
			"junegunn/vim-easy-align",
			init = function()
				vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {
					noremap = false,
					silent = true,
				})
			end,
		},
		-- TODO fix this
		{
			"folke/trouble.nvim",
			opts = {}, -- for default options, refer to the configuration section for custom setup.
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>Cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>Cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{ -- Useful plugin to show you pending keybinds.
			"folke/which-key.nvim",
			event = "VimEnter", -- Sets the loading event to 'VimEnter'
			opts = {
				-- delay between pressing a key and opening which-key (milliseconds)
				-- this setting is independent of vim.opt.timeoutlen
				delay = 0,
				icons = {
					-- set icon mappings to true if you have a Nerd Font
					mappings = vim.g.have_nerd_font,
					-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
					-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
					keys = vim.g.have_nerd_font and {} or {
						Up = "<Up> ",
						Down = "<Down> ",
						Left = "<Left> ",
						Right = "<Right> ",
						C = "<C-…> ",
						M = "<M-…> ",
						D = "<D-…> ",
						S = "<S-…> ",
						CR = "<CR> ",
						Esc = "<Esc> ",
						ScrollWheelDown = "<ScrollWheelDown> ",
						ScrollWheelUp = "<ScrollWheelUp> ",
						NL = "<NL> ",
						BS = "<BS> ",
						Space = "<Space> ",
						Tab = "<Tab> ",
						F1 = "<F1>",
						F2 = "<F2>",
						F3 = "<F3>",
						F4 = "<F4>",
						F5 = "<F5>",
						F6 = "<F6>",
						F7 = "<F7>",
						F8 = "<F8>",
						F9 = "<F9>",
						F10 = "<F10>",
						F11 = "<F11>",
						F12 = "<F12>",
					},
				},

				-- Document existing key chains
				spec = {
					{ "<leader>C", group = "[C]ode", mode = { "n", "x" } },
					{ "<leader>c", group = "Close", mode = { "n", "x" } },
					{ "<leader>a", group = "Settings File", mode = { "n", "x" } },
					{ "<leader>d", group = "[D]ocument" },
					{ "<leader>r", group = "[R]ename" },
					{ "<leader>s", group = "[S]earch" },
					{ "<leader>w", group = "[W]orkspace" },
					{ "<leader>t", group = "[T]oggle" },
					{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				},
			},
		},

		-- NOTE: Plugins can specify dependencies.
		--
		-- The dependencies are proper plugin specifications as well - anything
		-- you do for a plugin at the top level, you can do for a dependency.
		--
		-- Use the `dependencies` key to specify the dependencies of a particular plugin

		{ -- Fuzzy Finder (files, lsp, etc)
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			branch = "master",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ -- If encountering errors, see telescope-fzf-native README for installation instructions
					"nvim-telescope/telescope-fzf-native.nvim",

					-- `build` is used to run some command when the plugin is installed/updated.
					-- This is only run then, not every time Neovim starts up.
					build = "make",

					-- `cond` is a condition used to determine whether this plugin should be
					-- installed and loaded.
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },

				-- Useful for getting pretty icons, but requires a Nerd Font.
				{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			},
			config = function()
				-- Telescope is a fuzzy finder that comes with a lot of different things that
				-- it can fuzzy find! It's more than just a "file finder", it can search
				-- many different aspects of Neovim, your workspace, LSP, and more!
				--
				-- The easiest way to use Telescope, is to start by doing something like:
				--  :Telescope help_tags
				--
				-- After running this command, a window will open up and you're able to
				-- type in the prompt window. You'll see a list of `help_tags` options and
				-- a corresponding preview of the help.
				--
				-- Two important keymaps to use while in Telescope are:
				--  - Insert mode: <c-/>
				--  - Normal mode: ?
				--
				-- This opens a window that shows you all of the keymaps for the current
				-- Telescope picker. This is really useful to discover what Telescope can
				-- do as well as how to actually do it!

				-- [[ Configure Telescope ]]
				-- See `:help telescope` and `:help telescope.setup()`
				require("telescope").setup({
					-- You can put your default mappings / updates / etc. in here
					--  All the info you're looking for is in `:help telescope.setup()`
					--
					-- defaults = {
					--   mappings = {
					--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
					--   },
					-- },
					-- pickers = {}
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})

				-- Enable Telescope extensions if they are installed
				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				-- See `:help telescope.builtin`
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
				vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
				vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
				vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

				-- Slightly advanced example of overriding default behavior and theme
				vim.keymap.set("n", "<leader>/", function()
					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end, { desc = "[/] Fuzzily search in current buffer" })

				-- It's also possible to pass additional configuration options.
				--  See `:help telescope.builtin.live_grep()` for information about particular keys
				vim.keymap.set("n", "<leader>s/", function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end, { desc = "[S]earch [/] in Open Files" })

				-- Shortcut for searching your Neovim configuration files
				vim.keymap.set("n", "<leader>sn", function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},

		-- LSP Plugins
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			-- Main LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				-- Automatically install LSPs and related tools to stdpath for Neovim
				-- Mason must be loaded before its dependents so we need to set it up here.
				-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
				{ "williamboman/mason.nvim", opts = {} },
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				-- Useful status updates for LSP.
				{ "j-hui/fidget.nvim", opts = {} },

				-- Allows extra capabilities provided by nvim-cmp
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				-- Brief aside: **What is LSP?**
				--
				-- LSP is an initialism you've probably heard, but might not understand what it is.
				--
				-- LSP stands for Language Server Protocol. It's a protocol that helps editors
				-- and language tooling communicate in a standardized fashion.
				--
				-- In general, you have a "server" which is some tool built to understand a particular
				-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
				-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
				-- processes that communicate with some "client" - in this case, Neovim!
				--
				-- LSP provides Neovim with features like:
				--  - Go to definition
				--  - Find references
				--  - Autocompletion
				--  - Symbol Search
				--  - and more!
				--
				-- Thus, Language Servers are external tools that must be installed separately from
				-- Neovim. This is where `mason` and related plugins come into play.
				--
				-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
				-- and elegantly composed help section, `:help lsp-vs-treesitter`

				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						-- NOTE: Remember that Lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						-- Jump to the definition of the word under your cursor.
						--  This is where a variable was first declared, or where a function is defined, etc.
						--  To jump back, press <C-t>.
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

						-- Find references for the word under your cursor.
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

						-- Jump to the implementation of the word under your cursor.
						--  Useful when your language has ways of declaring types without an actual implementation.
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

						-- Jump to the type of the word under your cursor.
						--  Useful when you're not sure what type a variable is and you want to see
						--  the definition of its *type*, not where it was *defined*.
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

						-- Fuzzy find all the symbols in your current document.
						--  Symbols are things like variables, functions, types, etc.
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

						-- Fuzzy find all the symbols in your current workspace.
						--  Similar to document symbols, except searches over your entire project.
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map("<leader>Ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if
							client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
						then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end

						-- The following code creates a keymap to toggle inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				-- Change diagnostic symbols in the sign column (gutter)
				-- if vim.g.have_nerd_font then
				--   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
				--   local diagnostic_signs = {}
				--   for type, icon in pairs(signs) do
				--     diagnostic_signs[vim.diagnostic.severity[type]] = icon
				--   end
				--   vim.diagnostic.config { signs = { text = diagnostic_signs } }
				-- end

				-- LSP servers and clients are able to communicate to each other what features they support.
				--  By default, Neovim doesn't support everything that is in the LSP specification.
				--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
				--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				-- Enable the following language servers
				--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
				--
				--  Add any additional override configuration in the following tables. Available keys are:
				--  - cmd (table): Override the default command used to start the server
				--  - filetypes (table): Override the default list of associated filetypes for the server
				--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
				--  - settings (table): Override the default settings passed when initializing the server.
				--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
				local servers = {
					-- clangd = {},
					-- gopls = {},
					-- pyright = {},
					-- rust_analyzer = {},
					-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
					--
					-- Some languages (like typescript) have entire language plugins that can be useful:
					--    https://github.com/pmizio/typescript-tools.nvim
					--
					-- But for many setups, the LSP (`ts_ls`) will work just fine
					-- ts_ls = {},
					--

					lua_ls = {
						-- cmd = { ... },
						-- filetypes = { ... },
						-- capabilities = {},
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
								-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
								-- diagnostics = { disable = { 'missing-fields' } },
							},
						},
					},
				}

				-- Ensure the servers and tools above are installed
				--
				-- To check the current status of installed tools and/or manually install
				-- other tools, you can run
				--    :Mason
				--
				-- You can press `g?` for help in this menu.
				--
				-- `mason` had to be setup earlier: to configure its options see the
				-- `dependencies` table for `nvim-lspconfig` above.
				--
				-- You can add other tools here that you want Mason to install
				-- for you, so that they are available from within Neovim.
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
					"solargraph",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							-- This handles overriding only values explicitly passed
							-- by the server configuration above. Useful when disabling
							-- certain features of an LSP (for example, turning off formatting for ts_ls)
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},

		{ -- Autoformat
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>lf",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				formatters = {
					rubocop = {
						args = { "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
					},
				},
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use 'stop_after_first' to run the first available formatter from the list
					-- javascript = { "prettierd", "prettier", stop_after_first = true },
				},
			},
		},

		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						-- Build Step is needed for regex support in snippets.
						-- This step is not supported in many windows environments.
						-- Remove the below condition to re-enable on windows.
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						-- `friendly-snippets` contains a variety of premade snippets.
						--    See the README about individual language/framework/plugin snippets:
						--    https://github.com/rafamadriz/friendly-snippets
						-- {
						--   'rafamadriz/friendly-snippets',
						--   config = function()
						--     require('luasnip.loaders.from_vscode').lazy_load()
						--   end,
						-- },
					},
				},
				"saadparwaiz1/cmp_luasnip",

				-- Adds other completion capabilities.
				--  nvim-cmp does not ship with all sources by default. They are split
				--  into multiple repos for maintenance purposes.
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})
				local has_words_before = function()
					if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
						return false
					end
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
				end
				local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
				if not status_cmp_ok then
					return
				end
				local ConfirmBehavior = cmp_types.ConfirmBehavior
				local SelectBehavior = cmp_types.SelectBehavior
				---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
				---@param dir number 1 for forward, -1 for backward; defaults to 1
				---@return boolean true if a jumpable luasnip field is found while inside a snippet
				local function jumpable(dir)
					local luasnip_ok, luasnip = pcall(require, "luasnip")
					if not luasnip_ok then
						return false
					end

					local win_get_cursor = vim.api.nvim_win_get_cursor
					local get_current_buf = vim.api.nvim_get_current_buf

					---sets the current buffer's luasnip to the one nearest the cursor
					---@return boolean true if a node is found, false otherwise
					local function seek_luasnip_cursor_node()
						-- TODO(kylo252): upstream this
						-- for outdated versions of luasnip
						if not luasnip.session.current_nodes then
							return false
						end

						local node = luasnip.session.current_nodes[get_current_buf()]
						if not node then
							return false
						end

						local snippet = node.parent.snippet
						local exit_node = snippet.insert_nodes[0]

						local pos = win_get_cursor(0)
						pos[1] = pos[1] - 1

						-- exit early if we're past the exit node
						if exit_node then
							local exit_pos_end = exit_node.mark:pos_end()
							if
								(pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2])
							then
								snippet:remove_from_jumplist()
								luasnip.session.current_nodes[get_current_buf()] = nil

								return false
							end
						end

						node = snippet.inner_first:jump_into(1, true)
						while node ~= nil and node.next ~= nil and node ~= snippet do
							local n_next = node.next
							local next_pos = n_next and n_next.mark:pos_begin()
							local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
								or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

							-- Past unmarked exit node, exit early
							if n_next == nil or n_next == snippet.next then
								snippet:remove_from_jumplist()
								luasnip.session.current_nodes[get_current_buf()] = nil

								return false
							end

							if candidate then
								luasnip.session.current_nodes[get_current_buf()] = node
								return true
							end

							local ok
							ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
							if not ok then
								snippet:remove_from_jumplist()
								luasnip.session.current_nodes[get_current_buf()] = nil

								return false
							end
						end

						-- No candidate, but have an exit node
						if exit_node then
							-- to jump to the exit node, seek to snippet
							luasnip.session.current_nodes[get_current_buf()] = snippet
							return true
						end

						-- No exit node, exit from snippet
						snippet:remove_from_jumplist()
						luasnip.session.current_nodes[get_current_buf()] = nil
						return false
					end

					if dir == -1 then
						return luasnip.in_snippet() and luasnip.jumpable(-1)
					else
						return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
					end
				end
				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert" },

					-- For an understanding of why these mappings were
					-- chosen, you will need to read `:help ins-completion`
					--
					-- No, but seriously. Please read `:help ins-completion`, it is really good!
					mapping = cmp.mapping.preset.insert({
						["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
						["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
						["<Down>"] = cmp.mapping(
							cmp.mapping.select_next_item({ behavior = SelectBehavior.Select }),
							{ "i" }
						),
						["<Up>"] = cmp.mapping(
							cmp.mapping.select_prev_item({ behavior = SelectBehavior.Select }),
							{ "i" }
						),
						["<C-d>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-y>"] = cmp.mapping({
							i = cmp.mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
							c = function(fallback)
								if cmp.visible() then
									cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
								else
									fallback()
								end
							end,
						}),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							elseif jumpable(1) then
								luasnip.jump(1)
							elseif has_words_before() then
								-- cmp.complete()
								fallback()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						-- ["<CR>"] = cmp.mapping(function(fallback)
						-- 	if cmp.visible() then
						-- 		local confirm_opts = { select = false }
						-- 		local is_insert_mode = function()
						-- 			return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
						-- 		end
						-- 		if is_insert_mode() then -- prevent overwriting brackets
						-- 			confirm_opts.behavior = ConfirmBehavior.Insert
						-- 		end
						-- 		local entry = cmp.get_selected_entry()
						-- 		local is_copilot = entry and entry.source.name == "copilot"
						-- 		if is_copilot then
						-- 			confirm_opts.behavior = ConfirmBehavior.Replace
						-- 			confirm_opts.select = true
						-- 		end
						-- 		if cmp.confirm(confirm_opts) then
						-- 			return -- success, exit early
						-- 		end
						-- 	end
						-- 	fallback() -- if not exited early, always fallback
						-- end),
					}),
					sources = {
						{
							name = "lazydev",
							-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
							group_index = 0,
						},
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
						-- { name = "copilot" },
					},
				})
			end,
		},

		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			cond = config.enable_copilot,
			config = function()
				require("copilot").setup({
					panel = {
						enabled = true,
						auto_refresh = false,
						keymap = {
							jump_prev = "[[",
							jump_next = "]]",
							accept = "<CR>",
							refresh = "gr",
							open = "<M-CR>",
						},
						layout = {
							position = "bottom", -- | top | left | right | horizontal | vertical
							ratio = 0.4,
						},
					},
					suggestion = {
						enabled = true,
						auto_trigger = true,
						hide_during_completion = true,
						debounce = 75,
						keymap = {
							accept = "<M-l>",
							accept_word = false,
							accept_line = false,
							next = "<M-]>",
							prev = "<M-[>",
							dismiss = "<C-]>",
						},
					},
					filetypes = {
						yaml = false,
						markdown = false,
						help = false,
						gitcommit = false,
						gitrebase = false,
						hgcommit = false,
						svn = false,
						cvs = false,
						["."] = false,
					},
					copilot_node_command = "node", -- Node.js version must be > 18.x
					server_opts_overrides = {},
				})
			end,
		},
		{
			"zbirenbaum/copilot-cmp",
			cond = config.enable_copilot,
			config = function()
				require("copilot_cmp").setup()
			end,
		},

		{ -- You can easily change to a different colorscheme.
			-- Change the name of the colorscheme plugin below, and then
			-- change the command in the config to whatever the name of that colorscheme is.
			--
			-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
			"navarasu/onedark.nvim",
			priority = 1000, -- Make sure to load this before all the other start plugins.
			init = function()
				-- Load the colorscheme here.
				-- Like many other themes, this one has different styles, and you could load
				-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
				-- Lua
				require("onedark").setup({
					style = "darker",
				})
				require("onedark").load()
				-- You can configure highlights by doing something like:
				vim.cmd.hi("Comment gui=none")
			end,
		},

		-- Highlight todo, notes, etc in comments
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},

		{ "tpope/vim-surround" },
		{ -- Collection of various small independent plugins/modules
			"echasnovski/mini.nvim",
			config = function()
				-- Better Around/Inside textobjects
				--
				-- Examples:
				--  - va)  - [V]isually select [A]round [)]paren
				--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
				--  - ci'  - [C]hange [I]nside [']quote
				require("mini.ai").setup({ n_lines = 500 })

				-- Add/delete/replace surroundings (brackets, quotes, etc.)
				--
				-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
				-- - sd'   - [S]urround [D]elete [']quotes
				-- - sr)'  - [S]urround [R]eplace [)] [']
				-- require("mini.surround").setup()

				-- Simple and easy statusline.
				--  You could remove this setup call if you don't like it,
				--  and try some other statusline plugin
				local statusline = require("mini.statusline")
				-- set use_icons to true if you have a Nerd Font
				statusline.setup({ use_icons = vim.g.have_nerd_font })

				-- You can configure sections in the statusline by overriding their
				-- default behavior. For example, here we set the section for
				-- cursor location to LINE:COLUMN
				---@diagnostic disable-next-line: duplicate-set-field
				statusline.section_location = function()
					return "%2l:%-2v"
				end

				-- ... and there is more!
				--  Check out: https://github.com/echasnovski/mini.nvim
			end,
		},
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				vim.opt.termguicolors = true
				require("bufferline").setup({})
			end,
		},

		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"olimorris/neotest-rspec",
			},
			config = function()
				require("neotest").setup({
					adapters = {
						require("neotest-rspec")({
							rspec_cmd = function()
								return vim.tbl_flatten({
									"bundle",
									"exec",
									"rspec",
								})
							end,
						}),
					},
				})
			end,
		},
		{
			"olimorris/codecompanion.nvim",
			opts = {},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},

		-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
		-- init.lua. If you want these files, they are in the repository, so you can just download them and
		-- place them in the correct locations.

		-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
		--
		--  Here are some example plugins that I've included in the Kickstart repository.
		--  Uncomment any of the lines below to enable them (you will need to restart nvim).
		--
		-- require 'kickstart.plugins.debug',
		-- require 'kickstart.plugins.indent_line',
		-- require 'kickstart.plugins.lint',
		-- require 'kickstart.plugins.autopairs',
		-- require 'kickstart.plugins.neo-tree',
		-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

		-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
		--    This is the easiest way to modularize your config.
		--
		--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
		-- { import = 'custom.plugins' },
		--
		-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
		-- Or use telescope!
		-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
		-- you can continue same window with `<space>sr` which resumes last telescope search
	}, {
		ui = {
			-- If you are using a Nerd Font: set icons to an empty table which will use the
			-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
			icons = vim.g.have_nerd_font and {} or {
				cmd = "⌘",
				config = "🛠",
				event = "📅",
				ft = "📂",
				init = "⚙",
				keys = "🗝",
				plugin = "🔌",
				runtime = "💻",
				require = "🌙",
				source = "📄",
				start = "🚀",
				task = "📌",
				lazy = "💤 ",
			},
		},
	})
end

return M
