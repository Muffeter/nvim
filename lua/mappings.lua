local map = vim.keymap.set


map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Leader-/>", "gcc")
map("i", "jk", "<ESC>")
map('i', '<C-o>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
map("i", '<C-w>', '<Plug>(copilot-suggest)')

map("t", "<c-space>", "<C-\\><C-n>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
vim.g.copilot_no_tab_map = true



-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
print "hi"
