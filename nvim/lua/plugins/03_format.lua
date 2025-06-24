return {
	"stevearc/conform.nvim",
	dependencies = { "mason-org/mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			lua = { "stylua" },
			python = { "isort", "black" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			cmake = { "cmake_format" },
			rust = { "rustfmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "4" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
