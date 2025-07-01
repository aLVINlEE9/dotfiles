if vim.env.SSH_CONNECTION then
	local mac_username = "alvinlee"
	local key_path = vim.fn.expand("~/.ssh/clipboard_key")

	vim.g.clipboard = {
		name = "mac-clipboard-secure",
		copy = {
			["+"] = { "ssh", "-p", "22222", "-i", key_path, mac_username .. "@localhost", "copy" },
			["-"] = { "ssh", "-p", "22222", "-i", key_path, mac_username .. "@localhost", "copy" },
		},
		paste = {
			["+"] = { "ssh", "-p", "22222", "-i", key_path, mac_username .. "@localhost", "paste" },
			["-"] = { "ssh", "-p", "22222", "-i", key_path, mac_username .. "@localhost", "paste" },
		},
		cache_enabled = false,
	}
end
