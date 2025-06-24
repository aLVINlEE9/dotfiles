return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		local icons = {
			diagnostics = {
				Error = "󰅚 ",
				Warn = "󰀪 ",
				Hint = "󰌶 ",
				Info = " ",
			},
		}

		local diagnostics = {
			underline = true,
			update_in_insert = true,
			virtual_text = false,
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				},
			},
		}

		local inlay_hints = {
			enabled = true,
		}

		local codelens = {
			enabled = false,
		}

		local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		})

		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if has_cmp then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
		end

		local on_attach = function(client, bufnr)
			require("config.keymaps").setup_lsp(bufnr)
			local opts = { buffer = bufnr, silent = true }
			-- inlay hints (Neovim 0.10+)
			if vim.fn.has("nvim-0.10") == 1 and inlay_hints.enabled then
				if client.supports_method("textDocument/inlayHint") then
					local filetype = vim.bo[bufnr].filetype or ""
					local exclude_list = inlay_hints.exclude or {}
					if
						vim.api.nvim_buf_is_valid(bufnr)
						and vim.bo[bufnr].buftype == ""
						and not vim.tbl_contains(exclude_list, filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end
			end

			-- code lens (Neovim 0.10+)
			if vim.fn.has("nvim-0.10") == 1 and codelens.enabled and vim.lsp.codelens then
				if client.supports_method("textDocument/codeLens") then
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = bufnr,
						callback = vim.lsp.codelens.refresh,
					})
				end
			end
		end

		if vim.fn.has("nvim-0.10.0") == 0 then
			for severity, icon in pairs(diagnostics.signs.text) do
				local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
		end

		vim.diagnostic.config(diagnostics)

		local lspconfig = require("lspconfig")

		-- Lua
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
					},
					codeLens = {
						enable = true,
					},
					completion = {
						callSnippet = "Replace",
					},
					doc = {
						privateName = { "^_" },
					},
					hint = {
						enable = true,
						setType = false,
						paramType = true,
						paramName = "Disable",
						semicolon = "Disable",
						arrayIndex = "Disable",
					},
				},
			},
		})

		-- C/C++
		lspconfig.clangd.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--function-arg-placeholders",
			},
		})

		-- Rust
		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		})

		-- Python
		lspconfig.pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		-- Shell
		lspconfig.bashls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- CMake
		lspconfig.cmake.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
