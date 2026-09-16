local ctp_ok, ctp_bufferline = pcall(require, "catppuccin.special.bufferline")

return {
	options = {
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
		max_name_length = 30,
		max_prefix_length = 15,
		tab_size = 20,
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
	},
	highlights = ctp_ok and ctp_bufferline.get_theme() or nil,
}
