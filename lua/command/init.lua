local cmd = vim.api.nvim_create_user_command

cmd("Test", "echo 123", {})
cmd("Test2", function ()
  print("Test" .. 2)
end, {})


-- ref: https://neovim.io/doc/user/lua-guide.html#lua-guide-commands-create
