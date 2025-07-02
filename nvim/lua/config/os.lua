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
	if vim.env.SSH_CONNECTION then
		local function nav(dir)
			local curr = vim.fn.winnr()
			vim.cmd("wincmd " .. dir)
			if vim.fn.winnr() == curr then
				local tmux_dir = ({ h = "L", j = "D", k = "U", l = "R" })[dir]
				vim.fn.system("tmux select-pane -" .. tmux_dir)
			end
		end

		vim.keymap.set("n", "<C-h>", function()
			nav("h")
		end, { silent = true })
		vim.keymap.set("n", "<C-j>", function()
			nav("j")
		end, { silent = true })
		vim.keymap.set("n", "<C-k>", function()
			nav("k")
		end, { silent = true })
		vim.keymap.set("n", "<C-l>", function()
			nav("l")
		end, { silent = true })
		vim.keymap.set("n", "<C-\\>", function()
			vim.fn.system("tmux select-pane -l")
		end, { silent = true })

		vim.g.tmux_navigator_no_mappings = 1
	end
end
