-- vim.lsp.set_log_level("info")
local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
vim.lsp.config("*", {
    capabilities = capabilities,
  })
local lsp_servers = {
  {
    server = "lua_ls"
  },
  {
    server = "pyright",
    opt = {},
  },
  {
    server = "clangd",
    opt = {
      cmd = {
        "clangd",
        "--background-index",
        "--background-index-priority=normal",
        "-j=8",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--pch-storage=memory",
        "--fallback-style=Microsoft",
      },
    },
  },
  {
    server = "ts_ls"
  },
  {
    server = "cmake",
    opt = {
      filetypes = "CMakeLists.txt"
    }
  }
}
for i, v in ipairs(lsp_servers) do
  if v.opt and next(v.opt) then
    vim.lsp.config(v.server, v.opt)
  end
  vim.lsp.enable(v.server)
end

-- require("configs.lsp.lua_helper")
require("configs.lsp.ominisharp")
