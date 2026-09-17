local ctp_ok, ctp_bufferline = pcall(require, "catppuccin.special.bufferline")

local M = {}

M.view_buf_id = nil

function M.scroll_view(direction)
	local ok, state = pcall(require, "bufferline.state")
	if not ok or not state.components or #state.components == 0 then
		return
	end

	local items = state.components
	local cur_id = M.view_buf_id or vim.api.nvim_get_current_buf()
	local idx = 1
	for i, item in ipairs(items) do
		if item.id == cur_id then
			idx = i
			break
		end
	end

	local target_idx = math.max(1, math.min(#items, idx + (direction == "left" and -1 or 1)))
	M.view_buf_id = items[target_idx].id
	vim.cmd.redrawtabline()
end

function M.reset_view()
	if M.view_buf_id ~= nil then
		M.view_buf_id = nil
		vim.cmd.redrawtabline()
	end
end

local function hook_ui()
	local ok, ui = pcall(require, "bufferline.ui")
	if not ok or ui.__tabline_hooked then
		return
	end

	local orig_tabline = ui.tabline
	ui.tabline = function(items, tab_indicators)
		if M.view_buf_id and items and #items > 0 then
			local found = false
			for _, item in ipairs(items) do
				if item.id == M.view_buf_id then
					found = true
					break
				end
			end
			if found then
				local fake_items = {}
				for _, item in ipairs(items) do
					table.insert(
						fake_items,
						setmetatable({
							current = function()
								return item.id == M.view_buf_id
							end,
						}, { __index = item })
					)
				end
				items = fake_items
			else
				M.view_buf_id = nil
			end
		end
		return orig_tabline(items, tab_indicators)
	end
	ui.__tabline_hooked = true

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			M.view_buf_id = nil
		end,
	})
end

hook_ui()

return setmetatable(M, {
	__index = function(_, k)
		if k == "options" then
			return {
				mode = "buffers",
				themable = true,
				numbers = "ordinal",
				close_command = function(n)
					if _G.Snacks and _G.Snacks.bufdelete then
						_G.Snacks.bufdelete(n)
					else
						vim.cmd("bdelete! " .. n)
					end
				end,
				right_mouse_command = function(n)
					if _G.Snacks and _G.Snacks.bufdelete then
						_G.Snacks.bufdelete(n)
					else
						vim.cmd("bdelete! " .. n)
					end
				end,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 12,
				tab_size = 18,
				diagnostics = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
						separator = true,
					},
				},
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				sort_by = "insert_after_current",
			}
		elseif k == "highlights" then
			return ctp_ok and ctp_bufferline.get_theme({
				custom = {
					all = {
						separator = { fg = "#585b70" },
						separator_visible = { fg = "#585b70" },
						separator_selected = { fg = "#585b70" },
						tab_separator = { fg = "#585b70" },
						tab_separator_selected = { fg = "#585b70" },
						offset_separator = { fg = "#585b70" },
					},
				},
			}) or nil
		end
	end,
})
