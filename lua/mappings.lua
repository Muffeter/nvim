local map = vim.keymap.set
local unmap = vim.keymap.del
vim.g.mapleader = "<Space>"


map("n", ";", ":", { desc = "CMD enter command mode" })

-- move
map("n", "<C-h>", "^", { desc = "Move cursor beginning non char" })
map("n", "<C-l>", "$", { desc = "Move cursor end" })
map("i", "<C-h>", "<Left>", { desc = "Move cursor Left" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor Right" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor Down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor Up" })

-- modify
map("n", "dw", '"1dw', { desc = "delete word without copy into latest register" })
map("n", "dd", '"1dd', { desc = "delete line without copy into latest register" })
map("n", "cc", '"1cc', { desc = "cut word without copy into latest register" })
map("n", "cw", '"1cw', { desc = "cut line without copy into latest register" })
map("n", "<C-o>", "m`o<ESC>``", { desc = "new a line without going into insert mode" })
map("v", "<Tab>", ">", { desc = "indent right" })
map("v", "<S-Tab>", "<", { desc = "indent left" })

-- neo-tree
map("n", "<C-\\>", ":Neotree toggle<CR>", { desc = "Toggle the file explorer" })

-- lspconfig
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "Hover" } )
map("n", "gd", vim.lsp.buf.definition, { desc = "Go lsp definition" } )
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go lsp implementation"} )
-- map("n", "<A-S-f>", vim.lsp.buf.format)
-- map("i", "<A-S-f>", vim.lsp.buf.format)

-- conform
local conform = require("conform")
map("n", "<A-S-f>", function()
  conform.format({lsp_format = "fallback"}, function(err, did_edit) print("Format") end)
end)
map("i", "<A-S-f>", conform.format)

-- telescope
local builtin = require("telescope.builtin")
map("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "find text in current buffer" })
map("n", "<C-s>",
  function ()
    builtin.git_files{path_display = { "truncate" }}
  end, { desc = "find text across project" })

map("i", "jk", "<ESC>")
map("t", "<c-space>", "<C-\\><C-n>")
vim.g.copilot_no_tab_map = true

-- chore
map("n", "<ESC><ESC>", function ()
  -- remove find mark
  vim.cmd("noh")
  
end, { desc = "Remove find mark" })
