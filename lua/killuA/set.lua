--
-- set runtime path to nvim
-- vim.o.runtimepath = vim.o.runtimepath .. ',/home/killu/.config/nvim'


--log the o.runtimepath
-- print(vim.o.runtimepath)

-- vim.opt.ttimeoutlen = 10
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true


vim.opt.lazyredraw = true --disable redraw during macros


vim.opt.scrolloff = 8
-- vim.opt.sidescrolloff = 12

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 500

vim.opt.colorcolumn = "90"
-- vim.opt.textwidth = 80
vim.api.nvim_set_option("clipboard", "unnamed")





vim.keymap.set("n", "<leader>er", function()
    vim.diagnostic.open_float(nil, { focusable = false })
end, { desc = "Show diagnostics popup" })
