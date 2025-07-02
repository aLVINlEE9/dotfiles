if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh.exe"
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			io.write("\027]0;VIM_ACTIVE\007")
			io.flush()
		end,
	})
	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			io.write("\027]0;\007")
			io.flush()
		end,
	})
end
