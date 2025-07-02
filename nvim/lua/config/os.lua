if vim.fn.has("win32") == 1 then
	vim.o.shell = "pwsh.exe"
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
end
