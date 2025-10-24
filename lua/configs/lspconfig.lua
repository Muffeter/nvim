local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
local lsp_servers = {
  {
    server = "pyright",
    opt = {},
  },
  {
    server = "lua_ls",
    opt = {
      filetypes = "lua",
    }
  },
  {
    server = "ts_ls"
  }
}
for i, v in ipairs(lsp_servers) do
  vim.lsp.config(v.server, {
    capabilities = capabilities,
  })

  vim.lsp.enable(v.server)
end
