return {
	"nvim-treesitter/nvim-treesitter",

	build = ":TSUpdate",

	event = { "BufReadPost", "BufNewFile" },

	main = "nvim-treesitter.configs",

	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"elixir",
			"heex",
			"javascript",
			"rust",
			"python",
			"html",
			"regex",
			"bash",
		},
		sync_install = false,

		highlight = { enable = true },
		indent = { enable = true },
	},
}
