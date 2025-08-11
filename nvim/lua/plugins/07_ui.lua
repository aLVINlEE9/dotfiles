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
			require("nvim-tree").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
			})
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
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup({
				---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
				---Default is "medium".
				background = "hard",
				---How much of the background should be transparent. 2 will have more UI
				---components be transparent (e.g. status line background)
				transparent_background_level = 0,
				---Whether italics should be used for keywords and more.
				italics = true,
				---Disable italic fonts for comments. Comments are in italics by default, set
				---this to `true` to make them _not_ italic!
				disable_italic_comments = false,
				---By default, the colour of the sign column background is the same as the as normal text
				---background, but you can use a grey background by setting this to `"grey"`.
				sign_column_background = "none",
				---The contrast of line numbers, indent lines, etc. Options are `"high"` or
				---`"low"` (default).
				ui_contrast = "low",
				---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
				---
				---When this option is used in conjunction with show_eob set to `false`, the
				---end of the buffer will only be hidden inside the active window. Inside
				---inactive windows, the end of buffer filler characters will be visible in
				---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
				dim_inactive_windows = false,
				---Some plugins support highlighting error/warning/info/hint texts, by
				---default these texts are only underlined, but you can use this option to
				---also highlight the background of them.
				diagnostic_text_highlight = false,
				---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
				diagnostic_virtual_text = "coloured",
				---Some plugins support highlighting error/warning/info/hint lines, but this
				---feature is disabled by default in this colour scheme.
				diagnostic_line_highlight = false,
				---By default, this color scheme won't colour the foreground of |spell|, instead
				---colored under curls will be used. If you also want to colour the foreground,
				---set this option to `true`.
				spell_foreground = false,
				---Whether to show the EndOfBuffer highlight.
				show_eob = true,
				---Style used to make floating windows stand out from other windows. `"bright"`
				---makes the background of these windows lighter than |hl-Normal|, whereas
				---`"dim"` makes it darker.
				---
				---Floating windows include for instance diagnostic pop-ups, scrollable
				---documentation windows from completion engines, overlay windows from
				---installers, etc.
				---
				---NB: This is only significant for dark backgrounds as the light palettes
				---have the same colour for both values in the switch.
				float_style = "bright",
				---Inlay hints are special markers that are displayed inline with the code to
				---provide you with additional information. You can use this option to customize
				---the background color of inlay hints.
				---
				---Options are `"none"` or `"dimmed"`.
				inlay_hints_background = "none",
				---You can override specific highlights to use other groups or a hex colour.
				---This function will be called with the highlights and colour palette tables.
				---@param highlight_groups Highlights
				---@param palette Palette
				on_highlights = function(highlight_groups, palette) end,
				---You can override colours in the palette to use different hex colours.
				---This function will be called once the base and background colours have
				---been mixed on the palette.
				---@param palette Palette
				colours_override = function(palette) end,
			})
			vim.cmd([[colorscheme everforest]])
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
}
