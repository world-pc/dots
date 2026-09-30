vim.cmd("source ~/.vimrc")

-- for background transparency
local groups = { "Normal", "NormalFloat", "FloatBorder", "SignColumn", "LineNr" }
for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
end
