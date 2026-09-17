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
		branch = "master",
		build = ":TSUpdate",
		config = function()
			-- Fix Windows cmd.exe path separator issue in nvim-treesitter
			if vim.fn.has("win32") == 1 then
				require("nvim-treesitter.install").prefer_git = false
				local shell = require("nvim-treesitter.shell_command_selectors")

				local function normalize_cmd(cmd)
					if cmd and cmd.opts and cmd.opts.args then
						for i, arg in ipairs(cmd.opts.args) do
							if arg:sub(1, 1) ~= "/" and arg:find("/") then
								cmd.opts.args[i] = arg:gsub("/", "\\")
							end
						end
					end
					return cmd
				end

				local orig_rm = shell.select_install_rm_cmd
				shell.select_install_rm_cmd = function(cache_folder, project_name)
					return normalize_cmd(orig_rm(cache_folder, project_name))
				end

				local orig_rm_file = shell.select_rm_file_cmd
				shell.select_rm_file_cmd = function(file, info_msg)
					return normalize_cmd(orig_rm_file(file, info_msg))
				end

				local orig_mkdir = shell.select_mkdir_cmd
				shell.select_mkdir_cmd = function(directory, cwd, info_msg)
					return normalize_cmd(orig_mkdir(directory, cwd, info_msg))
				end

				local orig_mv = shell.select_mv_cmd
				shell.select_mv_cmd = function(from, to, cwd)
					return normalize_cmd(orig_mv(from, to, cwd))
				end
			end

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"c_sharp",
					"cpp",
					"python",
				},
				sync_install = false,
				auto_install = false,
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = {
					enable = true,
				},
			})

			local q = vim.treesitter.query
			local function unwrap_node(node)
				if type(node) == "table" and not node.range then
					return node[1]
				end
				return node
			end

			local aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				uxn = "uxntal",
				ts = "typescript",
			}

			q.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local capture_id = pred[2]
				local node = unwrap_node(match[capture_id])
				if not node then
					return
				end
				local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
				local filetype_match = vim.filetype.match({ filename = "a." .. injection_alias })
				metadata["injection.language"] = filetype_match or aliases[injection_alias] or injection_alias
			end, { force = true })

			q.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
				local id = pred[2]
				local node = unwrap_node(match[id])
				if not node then
					return
				end
				local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
				if not metadata[id] then
					metadata[id] = {}
				end
				metadata[id].text = string.lower(text)
			end, { force = true })
		end,
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
			local utils = require("telescope.utils")
			local orig_is_uri = utils.is_uri
			utils.is_uri = function(filename)
				if filename and filename:match("^[a-zA-Z]:[/\\]") then
					return false
				end
				return orig_is_uri(filename)
			end

			local format_path = function(_, path)
				local name = path:match("([^/\\]+)$") or path
				local dir = path:match("^(.-)[/\\][^/\\]+$")
				if dir and dir ~= "" then
					return string.format("%s  (%s)", name, dir)
				end
				return name
			end

			require("telescope").setup({
				defaults = {
					path_display = format_path,
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
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				transparent_background = false,
				term_colors = true,
				integrations = {
					treesitter = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					neotree = true,
					telescope = {
						enabled = true,
					},
					which_key = true,
					bufferline = true,
				},
			})
			-- Enable theme
			vim.cmd.colorscheme("catppuccin")
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
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			require("configs.scrollbar")
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			win = {
				height = { min = 4, max = 15 },
			},
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>p", group = "p4 (perforce)" },
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
	{
		"nvim-mini/mini.nvim",
		version = "*",
		config = function()
			require("configs.mini")
		end,
	},
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
		event = { "BufReadPost", "BufNewFile" },
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = function()
			return require("configs.bufferline")
		end,
	},
	{
		"coffebar/neovim-project",
		opts = {
			projects = { -- define project roots
				"C:/wddm",
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
			{ "nvim-telescope/telescope.nvim" },
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
