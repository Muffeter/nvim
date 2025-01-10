require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('i', '<C-i>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

print("hi")
vim.g.copilot_no_tab_map = true

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
