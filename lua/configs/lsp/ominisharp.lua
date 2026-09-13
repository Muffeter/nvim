local omnisharp_dll = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "omnisharp", "libexec", "OmniSharp.dll")

vim.lsp.config("omnisharp", {
	root_markers = { ".git", "*.sln", "*.csproj" },
	filetypes = { "cs" },
	cmd = {
		"dotnet",
		omnisharp_dll,
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
vim.lsp.enable("omnisharp")
