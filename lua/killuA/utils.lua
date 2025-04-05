vim.api.nvim_create_user_command('Rp', function()
    local find = vim.fn.input("Find: ")
    local replace = vim.fn.input("Replace with: ")
    if find ~= "" and replace ~= "" then
        vim.cmd(string.format("%%s/%s/%s/gc", vim.pesc(find), replace))
    end
end, {})

vim.api.nvim_create_user_command('Vimreg', function()
    vim.cmd('help regmap')
end, {})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tsx',
    callback = function()
        -- JSX/TSX uses block comments
        vim.bo.commentstring = '{/* %s */}'
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vue',
    callback = function()
        -- Vue single-file components use HTML-style comments
        vim.bo.commentstring = '<!-- %s -->'
    end
})
