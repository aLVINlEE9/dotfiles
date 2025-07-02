return {
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				suppressed_dirs = { "~/", "~/Downloads" },
			})
		end,
	},
	{
		"rmagatti/goto-preview",
		dependencies = { "rmagatti/logger.nvim" },
		event = "BufEnter",
		config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			notify = false,
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
		config = function()
			local is_tmux = vim.env.TMUX ~= nil

			if is_tmux then
				vim.api.nvim_create_autocmd("VimEnter", {
					group = vim.api.nvim_create_augroup("TmuxVimNavigator", { clear = true }),
					callback = function()
						io.write("\027]0;VIM_ACTIVE\007")
						io.flush()

						local success = pcall(vim.fn.system, "tmux set-environment VIM_TERMINAL 1")
						if not success then
							vim.env.VIM_TERMINAL = "1"
						end
					end,
				})
				vim.api.nvim_create_autocmd("VimLeave", {
					group = vim.api.nvim_create_augroup("TmuxVimNavigator", { clear = false }),
					callback = function()
						io.write("\027]0;\007")
						io.flush()

						pcall(vim.fn.system, "tmux set-environment -u VIM_TERMINAL")
						vim.env.VIM_TERMINAL = nil
					end,
				})
			end
		end,
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
	{
		"klen/nvim-config-local",
		config = function()
			require("config-local").setup({
				config_files = { ".nvim.lua", ".nvimrc", ".exrc" },
				hashfile = vim.fn.stdpath("data") .. "/config-local",
				autocommands_create = true,
				commands_create = true,
				silent = false,
				lookup_parents = false,
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<C-t>]],
				shade_terminals = false,
				start_in_insert = false,
				close_on_exit = true,
				winbar = {
					enabled = false,
					name_formatter = function(term)
						return term.name
					end,
				},
			})
		end,
	},
}
