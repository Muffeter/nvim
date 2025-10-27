local map = vim.keymap.set
vim.g.mapleader = "<Space>"


map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-o>", "m`o<ESC>``")

-- move 
map("n", "<C-h>", "^", { desc = "Move cursor beginning non char" })
map("n", "<C-l>", "$", { desc = "Move cursor end" } )
map("i", "<C-h>", "<Left>", { desc = "Move cursor Left" } )
map("i", "<C-l>", "<Right>", { desc = "Move cursor Right" } )
map("i", "<C-j>", "<Down>", { desc = "Move cursor Down" } )
map("i", "<C-k>", "<Up>", { desc = "Move cursor Up" } )

-- For nvim-tree
map("n", "<C-\\>", ":NvimTreeToggle<CR>")

-- lspconfig
map("n", "<C-k>", vim.lsp.buf.hover)
map("n", "<A-S-f>", vim.lsp.buf.format)




map("i", "jk", "<ESC>")
map('i', '<C-o>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
map("i", '<C-w>', '<Plug>(copilot-suggest)')

map("t", "<c-space>", "<C-\\><C-n>")
-- map("i", "<C-j>", "<Down>")
-- map("i", "<C-k>", "<Up>")
vim.g.copilot_no_tab_map = true



-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
print "hi"
