local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    vue = { "prettierd" },
    javascript = { "prettierd", "prettier", lsp_format = "fallback" },
    nix = { "nixpkgs_fmt" },
    tsx = { "prettierd" },
    cpp = { "clang-format" }
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

require("conform").setup(options)
