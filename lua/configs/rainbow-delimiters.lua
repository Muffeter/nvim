local rainbow_delimiters = require 'rainbow-delimiters'
-- 鲜艳红色（高对比度）
vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', {
    fg = '#FF4444',  -- 饱和红色
    ctermfg = 196    -- 标准亮红色
})

-- 柠檬黄（深色背景最佳）
vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', {
    fg = '#FFFF00',  -- 纯黄色
    ctermfg = 226    -- 亮黄色
})

-- 荧光绿（高可见性）
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', {
    fg = '#44FF44',  -- 荧光绿
    ctermfg = 46     -- 鲜绿色
})

-- 钴蓝色（不透明度最佳）
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', {
    fg = '#4488FF',  -- 中度饱和蓝
    ctermfg = 33     -- 明亮蓝色
})

-- 品红色（与蓝/红形成对比）
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', {
    fg = '#FF44FF',  -- 饱和品红
    ctermfg = 201    -- 亮紫色
})

-- 青色（与绿色形成对比）
vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', {
    fg = '#44FFFF',  -- 荧光青
    ctermfg = 51     -- 亮青色
})


---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterGreen",
      "RainbowDelimiterBlue",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    },
}
