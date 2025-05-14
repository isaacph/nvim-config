local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'nvim-telescope/telescope.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
    },
    {
        'ntk148v/habamax.nvim',
        dependencies = 'rktjmp/lush.nvim',
    },
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/playground',
    'ThePrimeagen/harpoon',
    'mbbill/undotree',
    'neovim/nvim-lspconfig',
    'nvim-tree/nvim-tree.lua',

    -- -- until they fix https://github.com/neovim/neovim/issues/25177
    -- 'hrsh7th/nvim-cmp',
    -- 'hrsh7th/cmp-vsnip',
    -- 'hrsh7th/vim-vsnip'

    -- 'nvimdev/epo.nvim', -- insanely bugged on Windows
    -- { 'echasnovski/mini.completion', version = '*' }, -- also broken
    -- { dir = 'C:\\workplace\\mini.completion' }, -- even if you stop it from completing too fast, still broken since relies on broken omnifunc

--     'hrsh7th/nvim-cmp',
--     'hrsh7th/cmp-nvim-lsp',
--     'saadparwaiz1/cmp_luasnip',
--     'L3MON4D3/LuaSnip',

    -- java
    'mfussenegger/nvim-jdtls',

    -- 'dense-analysis/ale',
})
