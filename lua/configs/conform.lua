local options = {
	formatters_by_ft = {
		lua = { "stylua", lsp_format = "fallback" },
		css = { "prettierd" },
		html = { "prettierd" },
		vue = { "prettierd" },
		javascript = { "prettierd", "prettier", lsp_format = "fallback" },
		nix = { "nixpkgs_fmt" },
		tsx = { "prettierd" },
		c = { "clang-format" },
		cpp = { "clang-format" },
    c_sharp = {"csharpier"},
    csharp = {"csharpier"},
    cs= {"csharpier"},
		["*"] = { "codespell" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters = {
		["clang-format"] = {
			prepend_args = function(self, ctx)
				local root = require("conform.util").root_file({ ".clang-format", "_clang-format" })(self, ctx)
				if not root then
					return {
						"--style={BasedOnStyle: LLVM, IndentWidth: 4, BreakBeforeBraces: Custom, BraceWrapping: {AfterControlStatement: Always, BeforeElse: true, AfterFunction: true}}",
					}
				end
				return {}
			end,
		},
	},
}

require("conform").setup(options)
