local M = {}
M.setup = function()
	-- The line beneath this is called `modeline`. See `:help modeline`
	-- vim: ts=2 sts=2 sw=2 et
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	local npairs = require("nvim-autopairs")
	npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
	npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
	npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
end

return M
