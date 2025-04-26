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
			require("nvchad.configs.lspconfig").defaults()
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
		"puremourning/vimspector",
		keys = {
			{ "<leader>t5", "<Plug>VimspectorContinue", desc = "continue" },
			{ "<leader>t3", "<Plug>VimspectorStop", desc = "stop" },
			{ "<leader>t2", "<Plug>VimspectorToggleBreakpoint", desc = "toggle breakpoint" },
			{ "<leader>t4", "<Plug>VimspectorRestart", desc = "restart" },
		},
		config = function()
			vim.g.vimspector_enable_mappings = "HUMAN"
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
		},
	},
	{
		"hrsh7th/nvim-cmp",
    enabled = false
		-- config = function()
			-- require("configs.nvim-cmp")
		-- end,
	},
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- },
	-- {
	-- 	"saadparwaiz1/cmp_luasnip",
	-- },
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
    "neoclide/coc.nvim",
    branch = "master",
    build = "npm ci",
    lazy = false
  }
}
