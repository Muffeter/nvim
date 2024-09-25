return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
        "python-lsp-server"
  		},
  	},
  },
  {
    "Muffeter/pluto.nvim",
    lazy = false,
    opts = {}
  },
  {
    'puremourning/vimspector',
    keys = {
      { "<leader>t5", "<Plug>VimspectorContinue", desc="continue"},
      { "<leader>t3", "<Plug>VimspectorStop", desc="stop"},
      { "<leader>t2", "<Plug>VimspectorToggleBreakpoint", desc="stop"},
      { "<leader>t4", "<Plug>VimspectorRestart", desc="restart"}
    },
    config = function ()
      vim.g.vimspector_enable_mappings = 'HUMAN'
    end,
  }
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
