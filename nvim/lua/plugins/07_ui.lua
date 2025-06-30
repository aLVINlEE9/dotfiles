return {
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset theme here
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to lsp docs
			},
		},
		dependencies = {
			-- if you lazy-load any of these icons, make sure to load them during startup
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",

		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{ "ryanoasis/vim-devicons" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/noice.nvim" },
		config = function()
			local os_icon = (function()
				local uname = vim.loop.os_uname().sysname:lower()
				if uname:match("linux") then
					local distro = vim.fn
						.system("lsb_release -si 2>/dev/null || cat /etc/os-release 2>/dev/null | grep '^ID=' | cut -d'=' -f2")
						:gsub("%s+", "")
						:lower()
					if distro:match("rocky") or distro:match("rhel") then
						return "󱄛"
					elseif distro:match("ubuntu") then
						return "󰕈"
					else
						return "󰌽"
					end
				elseif uname:match("darwin") then
					return ""
				elseif uname:match("windows") then
					return "󰖳"
				end
				return ""
			end)()

			require("lualine").setup({
				options = {
					icons_enabled = true,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_c = {
						{
							function()
								local icons = require("nvim-web-devicons")
								local folder_icon = icons.get_icon("folder", "folder", { default = true })
								return folder_icon .. " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
							end,
						},
						{ "filename" },
					},
					lualine_x = {
						{
							function()
								local ok, noice = pcall(require, "noice")
								if ok then
									return noice.api.statusline.mode.get()
								end
								return ""
							end,
							cond = function()
								local ok, noice = pcall(require, "noice")
								return ok and noice.api.statusline.mode.has()
							end,
						},
					},

					lualine_y = {
						{ "encoding" },
						function()
							return os_icon
						end,
						{ "filetype" },
					},
					lualine_z = {
						{ "progress" },
						{ "location" },
					},
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					style_preset = {
						bufferline.style_preset.no_italic,
						bufferline.style_preset.no_bold,
					},
					separator_style = "thick",
					show_buffer_close_icons = false,
				},
			})
		end,
	},
	{
		"folke/lazy.nvim",
		init = function()
			require("config.keymaps").setup_ui()
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				groups = {
					"Normal",
					"NormalNC",
					"Comment",
					"Constant",
					"Special",
					"Identifier",
					"Statement",
					"PreProc",
					"Type",
					"Underlined",
					"Todo",
					"String",
					"Function",
					"Conditional",
					"Repeat",
					"Operator",
					"Structure",
					"LineNr",
					"NonText",
					"SignColumn",
					"CursorLineNr",
					"EndOfBuffer",
				},
				extra_groups = {
					"NormalFloat",
					"FloatBorder",
					"FloatTitle",

					-- nvim-cmp
					"Pmenu",
					"PmenuSel",
					"PmenuSbar",
					"PmenuThumb",
					"CmpItemAbbr",
					"CmpItemAbbrDeprecated",
					"CmpItemAbbrMatch",
					"CmpItemAbbrMatchFuzzy",
					"CmpItemKind",
					"CmpItemMenu",

					-- NvimTree
					"NvimTreeNormal",
					"NvimTreeNormalNC",
					"NvimTreeEndOfBuffer",
					"NvimTreeWinSeparator",
					"NvimTreeStatusLine",
					"NvimTreeStatusLineNC",

					-- Telescope
					"TelescopeNormal",
					"TelescopePromptNormal",
					"TelescopeResultsNormal",
					"TelescopePreviewNormal",
					"TelescopePromptBorder",
					"TelescopeResultsBorder",
					"TelescopePreviewBorder",
					"TelescopePromptTitle",
					"TelescopeResultsTitle",
					"TelescopePreviewTitle",

					-- Trouble.nvim
					"TroubleNormal",
					"TroubleText",
					"TroubleCount",
					"TroubleError",
					"TroubleWarning",
					"TroubleInformation",
					"TroubleHint",

					-- GitSigns
					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
					"GitSignsTopDelete",
					"GitSignsChangeDelete",
					"GitSignsUntracked",

					-- Noice
					"NoicePopup",
					"NoicePopupBorder",
					"NoiceCmdline",
					"NoiceCmdlinePopup",
					"NoiceCmdlinePopupBorder",
					"NoiceCmdlineIcon",
					"NoiceConfirm",
					"NoiceConfirmBorder",

					-- TreeSitter
					"NormalSB",
					"MsgArea",

					-- Mason
					"MasonNormal",
					"MasonHeader",
					"MasonHeaderSecondary",

					-- Which-key
					"WhichKey",
					"WhichKeyGroup",
					"WhichKeyDesc",
					"WhichKeySeperator",
					"WhichKeyFloat",
					"WhichKeyBorder",

					-- Conform/Lint (status line)
					"StatusLine",
					"StatusLineNC",

					"WinSeparator",
					"VertSplit",
					"Folded",
					"FoldColumn",
					"TabLine",
					"TabLineFill",
					"TabLineSel",
				},
				exclude_groups = {
					"CursorLine",
					"CursorColumn",
					"ColorColumn",
					"MatchParen",
					"Visual",
					"VisualNOS",
					"Search",
					"IncSearch",
					"Substitute",

					-- Lualine
					"lualine_a_normal",
					"lualine_b_normal",
					"lualine_c_normal",
					"lualine_x_normal",
					"lualine_y_normal",
					"lualine_z_normal",
					"lualine_a_inactive",
					"lualine_b_inactive",
					"lualine_c_inactive",
					"lualine_x_inactive",
					"lualine_y_inactive",
					"lualine_z_inactive",

					-- BufferLine
					"BufferLineBackground",
					"BufferLineFill",
					"BufferLineTab",
					"BufferLineTabClose",
					"BufferLineTabSelected",
					"BufferLineSeparator",
					"BufferLineSeparatorSelected",
					"BufferLineSeparatorVisible",
				},
			})

			vim.g.transparent_enabled = true

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					if vim.g.transparent_enabled then
						vim.cmd("TransparentEnable")
					end
				end,
			})
		end,
	},
}
