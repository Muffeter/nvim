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

-- modify (use black hole register to avoid polluting clipboard/numbered registers)
map("n", "dw", '"_dw', { desc = "delete word without copying" })
map("n", "dd", '"_dd', { desc = "delete line without copying" })
map("n", "cc", '"_cc', { desc = "change line without copying" })
map("n", "cw", '"_cw', { desc = "change word without copying" })
map("n", "<C-o>", "m`o<ESC>``", { desc = "new a line without going into insert mode" })
map("v", "<Tab>", ">gv", { desc = "indent right and reselect" })
map("v", "<S-Tab>", "<gv", { desc = "indent left and reselect" })

-- copy paste
map("n", "<C-v>", '"*p', { desc = "paste" })
map("c", "<C-v>", '"*p', { desc = "paste in command" })
map("i", "<C-v>", '<Esc>"*pa', { desc = "paste in command" })
map("n", "<S-Insert>", '"*p', { desc = "paste" })

-- neo-tree
map("n", "<C-\\>", ":Neotree toggle<CR>", { desc = "Toggle the file explorer" })

-- lspconfig
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- conform
local conform = require("conform")
map("", "<A-S-f>", function() 	conform.format({ lsp_format = "fallback", async = true })end)

-- telescope
local builtin = require("telescope.builtin")
map("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "find text in current buffer" })
map("n", "<C-s>", function()
	builtin.git_files({ path_display = { "truncate" } })
end, { desc = "find text across project" })

map("i", "jk", "<ESC>")
map("t", "<c-space>", "<C-\\><C-n>")
vim.g.copilot_no_tab_map = true

-- chore
map("n", "<ESC><ESC>", function()
	-- remove find mark
	vim.cmd("noh")
end, { desc = "Remove find mark" })
