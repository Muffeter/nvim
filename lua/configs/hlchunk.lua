local lm = require("hlchunk.mods.line_num")
lm({
	style = "#9FFBB0",
  -- use_treesitter = true,
}):enable()

local chunk = require("hlchunk.mods.chunk")
chunk({
  delay = 0,
}):enable()
