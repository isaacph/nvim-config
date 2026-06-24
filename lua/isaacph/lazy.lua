local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "folke/which-key.nvim",
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'EdenEast/nightfox.nvim',
    -- "folke/tokyonight.nvim",
    -- { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', branch = 'main', lazy = false },
    -- 'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'neovim/nvim-lspconfig',
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },

    'AckslD/messages.nvim',

    -- completion (holy **** that's a lot for just one thing)
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',

    -- java
    'mfussenegger/nvim-jdtls',

    -- protobuf
    'dense-analysis/ale',

    -- debugging (java)
    'mfussenegger/nvim-dap',
})
