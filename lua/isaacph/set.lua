
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

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

vim.g.mapleader = " "

-- netrw tree view is bugged, this disables it
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_keepdir = 0
-- vim.g.netrw_banner = 0

vim.opt.completeopt={'menu','menuone','noselect'}

vim.opt.colorcolumn = nil

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 999
vim.opt.foldnestmax = 1

vim.opt.winborder = 'rounded'
