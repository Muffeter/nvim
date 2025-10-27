return {
	{
		-- For format code
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},
	{
		-- Code block shower
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
		opts = {},
		config = function()
			require("configs.rainbow-delimiters")
		end,
	},
	{
		-- lsp server support
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		event = "BufEnter",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"python-lsp-server",
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		config = function()
			require("configs.comment")
		end,
	},
	{
		"github/copilot.vim",
		lazy = true,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
			},
		}
	},
	{
		-- Compeletion
		require("configs.blink-cmp"),
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.hlchunk")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		enable = false,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		event = { "BufReadPre", "BufNewFile" },
		---@type snacks.Config
		opts = {
			animate = { enabled = true },
			bigfile = { enabled = true },
			indent = { enabled = false },
			input = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		config = function()
			require('outline').setup({
				providers = {
					priority = { 'coc' },
				},
			})
		end,
	},
	-- Using Lazy
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require('onedark').setup {
				style = 'darker',
				highlights = {
					["@variable"] = { fg = "#91AADF" },
					["@function"] = { fg = "#FFA066" },
					["@function.method"] = { fg = "#737c73" },
					["@constructor"] = { fg = "#b98d7b" },
					["@keyword.function"] = { fg = "#CF73E6" },
					["@type.cpp"] = { fg = "#68AD99" },
					["@variable.parameter"] = { fg = "#b8b4d0" },
					["@type.builtin"] = { fg = "#c7d7e0" }
				}
			}
			-- Enable theme
			require('onedark').load()
		end
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
		event = "CmdlineEnter",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			-- "ibhagwan/fzf-lua",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- configuration goes here
		},
	},
	{
		"honza/vim-snippets",
		event = "BufRead"
	},
	{
		"j-morano/buffer_manager.nvim",
		event = "BufNew",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			local buf = require("buffer_manager.ui")
			local map = vim.keymap.set
			map({ 't', 'n' }, "<M-b>", buf.toggle_quick_menu, { noremap = true })
		end,
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require('notify').setup({
				max_width = 200,
				max_height = 200
			})
		end
	},
	{
		"sheerun/vim-polyglot"
	},
	{
		"voldikss/vim-floaterm",
		event = "CmdlineEnter"
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
