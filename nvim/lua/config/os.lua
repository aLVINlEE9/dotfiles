if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh.exe"
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
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
