local dap = require("dap")

dap.adapters["local-lua"] = {
  type = "executable",
  command = "node",
  args = {
    "C:/Users/youku/AppData/Local/nvim-data/mason/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js"
  },
  enrich_config = function(config, on_config)
    if not config["extensionPath"] then
      local c = vim.deepcopy(config)
      -- 💀 If this is missing or wrong you'll see 
      -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
      c.extensionPath = "C:/Users/youku/AppData/Local/nvim-data/mason/packages/local-lua-debugger-vscode/"
      on_config(c)
    else
      on_config(config)
    end
  end,
}
dap.configurations.lua = {
	{
    name = "Launch current file",
    type = "local-lua", -- Matches the adapter name
    request = "launch",
    cwd = "${workspaceFolder}",
    program = {
      lua = "lua5.1", -- Or just "lua", depending on your system
      file = "${file}",
    },
    args = {},
  }
}
