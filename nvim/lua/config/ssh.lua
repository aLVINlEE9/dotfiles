if vim.env.SSH_CONNECTION then
	local mac_username = "alvinlee"

	vim.g.clipboard = {
		name = "mac-clipboard-ssh-tunnel",
		copy = {
			["+"] = { "ssh", "-p", "22222", mac_username .. "@localhost", "pbcopy" },
			["*"] = { "ssh", "-p", "22222", mac_username .. "@localhost", "pbcopy" },
		},
		paste = {
			["+"] = { "ssh", "-p", "22222", mac_username .. "@localhost", "pbpaste" },
			["*"] = { "ssh", "-p", "22222", mac_username .. "@localhost", "pbpaste" },
		},
		cache_enabled = false,
	}
end

vim.opt.clipboard = "unnamedplus"
