require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
local enable_providers = {
  "python3_provider",
  "node_provider",
  -- and so on
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end

vim.g.vimspector_base_dir='C:/Users/ming/AppData/Local/nvim-data/lazy/vimspector'
require 'nvim-treesitter.install'.compilers = { "gcc" }
