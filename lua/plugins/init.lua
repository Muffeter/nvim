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
		tag = "v0.10.0",
		build = ":TSUpdate",
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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
						},
					},
				},
			})
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		config = function()
			require("outline").setup({
				providers = {
					priority = { "lsp" },
				},
			})
		end,
	},
	-- Using Lazy
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "darker",
				highlights = {
					["@variable"] = { fg = "#91AADF" },
					["@function"] = { fg = "#FFA066" },
					["@function.method"] = { fg = "#737c73" },
					["@constructor"] = { fg = "#b98d7b" },
					["@keyword.function"] = { fg = "#CF73E6" },
					["@type.cpp"] = { fg = "#68AD99" },
					["@variable.parameter"] = { fg = "#b8b4d0" },
					["@type.builtin"] = { fg = "#c7d7e0" },
				},
			})
			-- Enable theme
			require("onedark").load()
		end,
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
		event = "BufRead",
	},
	{
		"j-morano/buffer_manager.nvim",
		event = "BufNew",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("buffer_manager").setup({
				short_file_names = true,
			})
			local buf = require("buffer_manager.ui")
			local map = vim.keymap.set
			map({ "t", "n" }, "<M-z>", buf.toggle_quick_menu, { noremap = true })
		end,
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
		lazy = false,
	},
	{
		"sheerun/vim-polyglot",
	},
	{
		"voldikss/vim-floaterm",
		event = "CmdlineEnter",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			window = {
				width = 40,
			},
			indent = {
				indent_size = 1,
			},
			filesystem = {
				filtered_items = {
					hide_by_pattern = {

						"*.meta",
					},
				},
			},
		},
	},
	{
		-- code diagnostics panel
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
	-- {
	-- 	-- mason automatic setup
	-- 	"mason-org/mason-lspconfig.nvim",
	-- 	opts = {},
	-- 	dependencies = {
	-- 		{ "mason-org/mason.nvim", opts = {} },
	-- 		"neovim/nvim-lspconfig",
	-- 	}
	-- },
	-- {
	-- 	dir = "D:/work/danm.nvim/",
	-- 	opts = {},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- },
	{
		-- For git highlight
		"lewis6991/gitsigns.nvim",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			win = {
				height = { min = 4, max = 15 },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{ "nvim-mini/mini.nvim", version = "*" },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"coffebar/neovim-project",
		opts = {
			projects = { -- define project roots
				"D:/workSpace/FISHU3D/CatchFishU3D",
				"~/AppData/Local/nvim",
				"D:/workSpace/FISHU3D/CatchFishU3D/Fishing3D/Assets/Editor/unity_tool",
			},
			picker = {
				type = "telescope", -- one of "telescope", "fzf-lua", or "snacks"
			},
		},
		init = function()
			-- enable saving the state of plugins in the session
			vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			-- optional picker
			{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
			{ "Shatur/neovim-session-manager" },
		},
		lazy = false,
		priority = 100,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
	{
		"seblyng/roslyn.nvim",
	},
}
