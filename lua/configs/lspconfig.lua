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
  -- {
  --   server = "lua_ls"
  -- },
  {
    server = "pyright",
    opt = {},
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
  vim.lsp.enable(v.server)
end

require("configs.lsp.lua_helper")
