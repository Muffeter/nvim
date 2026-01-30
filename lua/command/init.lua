local cmd = vim.api.nvim_create_user_command

cmd("Test", "echo 123", {})
cmd("Test2", function ()
  print("Test" .. 2)
end, {})

-- Close all buffers but the current one
cmd("ClearBuffer", "%bd|e#", {})
-- Update the config
local configPaht = vim.fn.stdpath('config')
cmd("UpdateBygit", "!git -C " .. configPaht .. " pull", {})


-- ref: https://neovim.io/doc/user/lua-guide.html#lua-guide-commands-create
