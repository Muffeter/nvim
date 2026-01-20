local options = {
	formatters_by_ft = {
		lua = { "stylua", lsp_format = "fallback" },
		css = { "prettierd" },
		html = { "prettierd" },
		vue = { "prettierd" },
		javascript = { "prettierd", "prettier", lsp_format = "fallback" },
		nix = { "nixpkgs_fmt" },
		tsx = { "prettierd" },
		cpp = { "clang-format" },
    c_sharp = {"clang-format"},
		["*"] = { "codespell" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
}

require("conform").setup(options)
