local M = {}

function M.setup_global()
	-- space bar leader key
	vim.g.mapleader = " "

	-- windows
	vim.keymap.set("n", "<leader><left>", ":vertical resize +20<cr>")
	vim.keymap.set("n", "<leader><right>", ":vertical resize -20<cr>")
	vim.keymap.set("n", "<leader><up>", ":resize +10<cr>")
	vim.keymap.set("n", "<leader><down>", ":resize -10<cr>")

	-- buffers
	vim.keymap.set("n", "<leader>n", ":bn<cr>")
	vim.keymap.set("n", "<leader>p", ":bp<cr>")
	vim.keymap.set("n", "<leader>x", ":bd<cr>")
	vim.keymap.set("n", "<leader>ml", ":b#<cr>")

	-- unhilight
	vim.keymap.set("n", "<leader>H", ":noh<cr>")

	-- move a blocks of text up/down with K/J in visual mode
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

	-- Center the screen after scrolling up/down with Ctrl-u/d
	vim.keymap.set("n", "<C-u>", "<C-u>zz")
	vim.keymap.set("n", "<C-d>", "<C-d>zz")

	-- Center the screen on the next/prev search result with n/N
	vim.keymap.set("n", "n", "nzzzv")
	vim.keymap.set("n", "N", "Nzzzv")

	-- Paste in visual mode without yanking replaced text
	vim.keymap.set("x", "p", [["_dP]])

	-- yank to clipboard
	vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
	-- yank line to clipboard
	vim.keymap.set("n", "<leader>Y", [["+Y]])

	-- delete without yanking
	vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

	-- map Ctrl-c to Escape
	vim.keymap.set("i", "<C-c>", "<Esc>")

	-- move 5 lines up/down with arrow keys
	vim.keymap.set("n", "<Down>", "5j")
	vim.keymap.set("n", "<Up>", "5k")

	-- move to underscores with - and l (repeatable with ";")
	vim.keymap.set({ "n", "v" }, "<leader>-", "f_", { silent = true })
	vim.keymap.set({ "n", "v" }, "<leader>l", "F_", { silent = true })

	-- search and replace the word under cursor in the file with <leader>s
	vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

	vim.keymap.set("n", "<C-h>", "<C-w>h")
	vim.keymap.set("n", "<C-l>", "<C-w>l")
	vim.keymap.set("n", "<C-j>", "<C-w>j")
	vim.keymap.set("n", "<C-k>", "<C-w>k")
end

function M.setup_lsp(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr, desc = "LSP" }
	opts.desc = "Goto Definition"
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

	opts.desc = "Goto Implementation"
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

	opts.desc = "Goto Type Definition"
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

	opts.desc = "Show References"
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	opts.desc = "Goto Declaration"
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Hover Documentation"
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "Goto Preview Definition"
	vim.keymap.set("n", "<leader>gd", function()
		require("goto-preview").goto_preview_definition()
	end, opts)

	opts.desc = "Goto Preview Type Definition"
	vim.keymap.set("n", "<leader>gt", function()
		require("goto-preview").goto_preview_type_definition()
	end, opts)

	opts.desc = "Goto Preview Implementation"
	vim.keymap.set("n", "<leader>gi", function()
		require("goto-preview").goto_preview_implementation()
	end, opts)

	opts.desc = "Close Goto Preview"
	vim.keymap.set("n", "<leader>gp", function()
		require("goto-preview").close_all_win()
	end, opts)
end

function M.setup_cmp_snip()
	local luasnip = require("luasnip")

	-- Snippet navigation (LuaSnip)
	vim.keymap.set({ "i", "s" }, "<C-l>", function()
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		end
	end, { silent = true, desc = "Snippet Jump Forward" })

	vim.keymap.set({ "i", "s" }, "<C-h>", function()
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		end
	end, { silent = true, desc = "Snippet Jump Backward" })
end

function M.setup_cmp()
	local cmp = require("cmp")
	return cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-p>"] = cmp.mapping.complete(),
	})
end

function M.setup_telescope()
	local builtin = require("telescope.builtin")
	local opts = { noremap = true, silent = true }

	opts.desc = "Find files"
	vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)

	opts.desc = "Live grep (find text in files)"
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)

	opts.desc = "Find open buffers"
	vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)

	opts.desc = "Find help tags"
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)

	opts.desc = "Find git files"
	vim.keymap.set("n", "<leader>gf", builtin.git_files, opts)

	opts.desc = "Find diagnostics"
	vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)
end

function M.setup_ui()
	local opts = { noremap = true, silent = true }

	opts.desc = "Toggle NvimTree"
	vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

	opts.desc = "Go to previous buffer"
	vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
	opts.desc = "Go to next buffer"
	vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
	opts.desc = "Close current buffer"
	vim.keymap.set("n", "<leader>bc", ":bdelete<CR>", opts)

	opts.desc = "Toggle diagnostics (Trouble)"
	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts)
	opts.desc = "Toggle buffer diagnostics (Trouble)"
	vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
	opts.desc = "Toggle symbols (Trouble)"
	vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", opts)
end

return M
