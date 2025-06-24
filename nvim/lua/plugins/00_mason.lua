return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate",
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		local ensure_installed = {
			-- LSPs

			-- Formatters
			"shfmt",
			"stylua",
			"isort",
			"black",
			"clang-format",
			"rustfmt",
			"prettierd",
			"prettier",
		}

		local mr = require("mason-registry")

		mr:on("package:install:success", function()
			vim.defer_fn(function()
				require("lazy.core.handler.event").trigger({
					event = "FileType",
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)

		mr.refresh(function()
			for _, tool in ipairs(ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end)
	end,
}
