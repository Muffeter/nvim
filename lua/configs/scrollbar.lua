local scrollbar = require("scrollbar")

scrollbar.setup({
	show = true,
	show_in_active_only = false,
	set_highlights = true,
	folds = 1000,
	max_lines = false,
	hide_if_all_visible = false,
	throttle_ms = 100,
	handle = {
		text = " ",
		blend = 0,
		highlight = "PmenuThumb",
		hide_if_all_visible = true,
	},
	marks = {
		Cursor = {
			text = "•",
			priority = 0,
			highlight = "Normal",
		},
		Search = {
			text = { "-", "=" },
			priority = 1,
			highlight = "Search",
		},
		Error = {
			text = { "-", "=" },
			priority = 2,
			highlight = "DiagnosticVirtualTextError",
		},
		Warn = {
			text = { "-", "=" },
			priority = 3,
			highlight = "DiagnosticVirtualTextWarn",
		},
		Info = {
			text = { "-", "=" },
			priority = 4,
			highlight = "DiagnosticVirtualTextInfo",
		},
		Hint = {
			text = { "-", "=" },
			priority = 5,
			highlight = "DiagnosticVirtualTextHint",
		},
		Misc = {
			text = { "-", "=" },
			priority = 6,
			highlight = "Normal",
		},
		GitAdd = {
			text = "▎",
			priority = 7,
			highlight = "GitSignsAdd",
		},
		GitChange = {
			text = "▎",
			priority = 7,
			highlight = "GitSignsChange",
		},
		GitDelete = {
			text = " ",
			priority = 7,
			highlight = "GitSignsDelete",
		},
	},
	excluded_buftypes = {
		"terminal",
	},
	excluded_filetypes = {
		"dropbar_menu",
		"dropbar_menu_icon",
		"cmp_docs",
		"cmp_menu",
		"noice",
		"prompt",
		"TelescopePrompt",
		"which-key",
	},
	handlers = {
		cursor = false,
		diagnostic = true,
		gitsigns = true,
		handle = true,
		search = false,
	},
})
