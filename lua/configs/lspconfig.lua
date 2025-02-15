-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = { "lua_ls", "rust_analyzer", "ts_ls", "unocss" }

local my_on_attach = function(_, bufnr)
	on_attach(_, bufnr)
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		-- disable virtual text
		virtual_text = false,

		-- show signs
		signs = true,

		-- delay update diagnostics
		update_in_insert = false,
	})
end

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		-- on_attach = on_attach,
    on_attach = my_on_attach,
		on_init = on_init,
		capabilities = require('cmp_nvim_lsp').default_capabilities(),
	})
end

-- python
require("lspconfig").pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { "W391" },
					maxLineLength = 100,
				},
			},
		},
	},
})
