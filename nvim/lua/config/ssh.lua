if vim.env.SSH_TTY then
	vim.opt.clipboard = ""
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			local osc52 = require("vim.ui.clipboard.osc52")
			local lines = vim.fn.getreg('"', 1, true)
			osc52.copy("+")(lines, vim.v.event.regtype)
		end,
	})
else
	vim.opt.clipboard = "unnamedplus"
end
