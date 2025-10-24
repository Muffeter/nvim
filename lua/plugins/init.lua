return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = false,
		opts = {},
		config = function()
			require("configs.rainbow-delimiters")
		end,
	},
	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
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
		lazy = false,
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
		require("configs.blink-cmp")
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
		'projekt0n/github-nvim-theme', name = 'github-theme'
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
					["@function"] = { fg = "#ffb86c" },
					["@function.method"] = { fg = "#ffb86c" },
					["@keyword.function"] = { fg = "#CF73E6" },
				}
			}
			-- Enable theme
			require('onedark').load()
		end
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
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
		"honza/vim-snippets"
	},
	{
		"j-morano/buffer_manager.nvim",
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
			vim.notify = require('notify')
			vim.notify("The Notifier init", "info")
		end
	},
	{
		"sheerun/vim-polyglot"
	},
	{
		"voldikss/vim-floaterm"
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end
	}
}
