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
        'folke/lazy.nvim',
        opts = {
            ui = {
                border = 'rounded',
            }
        }
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    'ThePrimeagen/harpoon',
    'mbbill/undotree',
    -- 'nvim-tree/nvim-tree.lua', -- stopped working on windows
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
    },
    {
        "romus204/tree-sitter-manager.nvim",
        branch = "develop",
    },

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
    -- 'mfussenegger/nvim-jdtls',

    -- 'dense-analysis/ale',
})
