if not vim.g.neovide then
  return
end

vim.g.neovide_scale_factor = 0.8
-- vim.g.neovide_padding_top = 1
vim.g.neovide_title_background_color = string.format(
    "%x",
    vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).bg
)
