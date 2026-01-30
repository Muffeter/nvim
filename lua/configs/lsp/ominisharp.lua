vim.lsp.config("ominisharp", {
	root_markers = {".git"},
	filetypes = { "cs" },
	cmd = {
		"dotnet",
		vim.fn.stdpath("data") .. "\\mason\\packages\\omnisharp\\libexec\\OmniSharp.dll",
	},
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = false,
			OrganizeImports = true,
		},
		Sdk = {
			IncludePrereleases = true,
		},
	},
})
vim.lsp.enable("ominisharp")
