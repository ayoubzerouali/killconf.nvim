-- vim.filetype.add({
--   extension = {
--     ['blade.php'] = 'blade',
--   },
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "blade", "blade.php" },
--     callback = function()
--         vim.bo.filetype = "blade"
--     end
-- })
-- require("conform").setup({
--     formatters_by_ft = {
--         blade = { "blade-formatter" }
--     },
-- })
vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
})
