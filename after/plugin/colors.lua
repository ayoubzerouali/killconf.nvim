function ColorMyPencils(color)
    -- color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    --
    vim.api.nvim_set_hl(0, "@variable", { fg = "#FFA500" })      -- Cyan for variables
    vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#7851a9" }) -- Cyan for variables

    -- vim.api.nvim_set_hl(0, "@type", { fg = "#FFA500" })     -- Orange for React components
    vim.api.nvim_set_hl(0, "@tag.builtin", { fg = "#fa5b3d" }) -- Light blue for built-in tags
    vim.api.nvim_set_hl(0, "@tag", { fg = "#fe6f5e" })      -- Orange for custom React tags    -- vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
    vim.api.nvim_set_hl(0, "@character.special", { fg = "#2e2eff" })      -- Orange for custom React tags    -- vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
    -- vim.api.nvim_set_hl(0, "@tag.delimeter", { fg = "#00FFFF" }) -- Green for custom React tags    -- vim.api.nvim_set_hl(0,"Normal",{bg = "none"})

    vim.api.nvim_set_hl(0, "Normal", { bg = "black" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "Comment", { fg = "#87CEFA" })
end

ColorMyPencils()
