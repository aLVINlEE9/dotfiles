vim.opt.encoding = "utf-8" -- set encoding
vim.opt.fileformats = { "unix", "dos" }
vim.opt.fileencodings = { "ucs-bom", "utf-8", "cp949", "latin1" }

vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = true -- relative line numbers

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- convert tabs to spaces

vim.opt.fixendofline = true
vim.opt.endofline = true

vim.opt.autoindent = true -- auto indentation
vim.opt.list = true -- show tab characters and trailing whitespace
vim.opt.formatoptions:remove("t") -- no auto-intent of line breaks, keep line wrap enabled
vim.opt.listchars = "tab:»\\ ,extends:›,precedes:‹,nbsp:·,trail:·" -- show tab characters and trailing whitespace

vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- unless capital letter in search

vim.opt.swapfile = false -- do not use a swap file for the buffer
vim.opt.backup = false -- do not keep a backup file

if vim.fn.has("win32") == 1 then
	vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

local undodir = vim.fn.expand(vim.opt.undodir:get()[1])
if not vim.fn.isdirectory(undodir) then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true -- save undo history to a file

vim.opt.hlsearch = false -- do not highlight all matches on previous search pattern
vim.opt.incsearch = true -- incrementally highlight searches as you type

vim.opt.termguicolors = true -- enable true color support

vim.opt.scrolloff = 8 -- minimum number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 --minimum number of columns to keep above and below the cursor
vim.opt.signcolumn = "yes" -- always show the sign column, to avoid text shifting when signs are displayed

vim.opt.updatetime = 50 -- Time in milliseconds to wait before triggering the plugin events after a change

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
}) -- return to last edit position when opening files

local HighlightYank = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = HighlightYank,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
}) -- highlight yanked text using the 'IncSearch' highlight group for 40ms

local CleanOnSave = vim.api.nvim_create_augroup("CleanOnSave", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = CleanOnSave,
	pattern = "*",
	command = [[%s/\s\+$//e]],
}) -- remove trailing whitespace from all lines before saving a file

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
