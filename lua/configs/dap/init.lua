local dapui = require("dapui")
dapui.setup()

local map = vim.keymap.set

map("n", "<leader>do", dapui.open)
map("n", "<leader>dc", dapui.close)
map("n", "<leader>dt", dapui.toggle)

require("configs.dap.lua")
