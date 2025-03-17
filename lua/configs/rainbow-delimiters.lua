local rainbow_delimiters = require 'rainbow-delimiters'
-- 鲜艳红色（高对比度）
vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', {
    fg = '#DB7100',  -- 饱和红色
    ctermfg = 196    -- 标准亮红色
})

-- 柠檬黄（深色背景最佳）
vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', {
    fg = '#E8BA36',  -- 纯黄色
    ctermfg = 226    -- 亮黄色
})

-- 荧光绿（高可见性）
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', {
    fg = '#54A857',  -- 荧光绿
    ctermfg = 46     -- 鲜绿色
})

-- 钴蓝色（不透明度最佳）
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', {
    fg = '#359FF4',  -- 中度饱和蓝
    ctermfg = 33     -- 明亮蓝色
})

-- 品红色（与蓝/红形成对比）
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', {
    fg = '#5060BB',  -- 饱和品红
    ctermfg = 201    -- 亮紫色
})

-- 青色（与绿色形成对比）
vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', {
    fg = '#179387',  -- 荧光青
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
