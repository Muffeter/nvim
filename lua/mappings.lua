local map = vim.keymap.set
local unmap = vim.keymap.del

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

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer Tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer Tab" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer Tab" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer Tab" })
map("n", "<A-.>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Tab Right" })
map("n", "<A-,>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Tab Left" })

local function handle_mouse_wheel(action, normal_key)
	local pos = vim.fn.getmousepos()
	if pos.screenrow == 1 and pos.winrow == 0 then
		local bl_cfg = package.loaded["configs.bufferline"] or require("configs.bufferline")
		if action == "scroll_left" then
			bl_cfg.scroll_view("left")
		elseif action == "scroll_right" then
			bl_cfg.scroll_view("right")
		end
		return ""
	end
	return normal_key
end

map({ "n", "v", "i" }, "<ScrollWheelUp>", function()
	return handle_mouse_wheel("scroll_left", "<ScrollWheelUp>")
end, { expr = true, desc = "Scroll tabline left or scroll window up" })

map({ "n", "v", "i" }, "<ScrollWheelDown>", function()
	return handle_mouse_wheel("scroll_right", "<ScrollWheelDown>")
end, { expr = true, desc = "Scroll tabline right or scroll window down" })

map({ "n", "v", "i" }, "<ScrollWheelLeft>", function()
	return handle_mouse_wheel("scroll_left", "<ScrollWheelLeft>")
end, { expr = true, desc = "Scroll tabline left or scroll window left" })

map({ "n", "v", "i" }, "<ScrollWheelRight>", function()
	return handle_mouse_wheel("scroll_right", "<ScrollWheelRight>")
end, { expr = true, desc = "Scroll tabline right or scroll window right" })

local function close_buffer()
	if _G.Snacks and _G.Snacks.bufdelete then
		_G.Snacks.bufdelete()
	else
		local bufnr = vim.api.nvim_get_current_buf()
		vim.cmd("bdelete! " .. bufnr)
	end
end

map("n", "<A-w>", close_buffer, { desc = "Close current buffer" })
map("n", "<leader>bd", close_buffer, { desc = "Close current buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin buffer" })

for i = 1, 9 do
	map("n", "<leader>" .. i, function()
		require("bufferline").go_to(i, true)
	end, { desc = "Go to buffer tab " .. i })
end

map("n", "]c", function() require("p4").next_hunk() end, { desc = "P4 Next Hunk" })
map("n", "[c", function() require("p4").prev_hunk() end, { desc = "P4 Prev Hunk" })
map("n", "<leader>pd", function() require("p4").preview_diff() end, { desc = "P4 Preview Diff" })
map("n", "<leader>po", function() require("p4").opened_files() end, { desc = "P4 Opened Files" })
map("n", "<leader>pe", function() require("p4").edit_file() end, { desc = "P4 Edit (Checkout)" })
map("n", "<leader>pr", function() require("p4").refresh() end, { desc = "P4 Refresh Signs" })

-- lspconfig
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "<A-o>", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (Clangd)" })
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
	local ok = pcall(builtin.git_files)
	if not ok then
		builtin.find_files()
	end
end, { desc = "find text across project (git or fallback to find_files)" })

map("i", "jk", "<ESC>")
map("t", "<c-space>", "<C-\\><C-n>")
vim.g.copilot_no_tab_map = true

-- chore
map("n", "<ESC><ESC>", function()
	-- remove find mark
	vim.cmd("noh")
end, { desc = "Remove find mark" })
