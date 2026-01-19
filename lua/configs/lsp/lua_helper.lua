local lsp_exe_path = "D:/gitrepo/LuaHelper/luahelper-lsp/luahelper-lsp.exe"

-- check exe exist
local f = io.open(lsp_exe_path, "r")
if f == nil then
      vim.notify("lua_helper lsp exe not exist!", "error")
      return
else
      io.close(f)
end

local lua_helper = {
      cmd = {lsp_exe_path, "-mode", "1"},
      filetype = {"lua"},
      name = "lua_helper",
      root_markers = {".git"}
}
vim.lsp.config("lua_helper", lua_helper);
vim.lsp.enable("lua_helper");

