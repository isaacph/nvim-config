vim.treesitter.language.add(
    'haskell',
    { path = "/home/isaac/.local/share/nvim/tree-sitter-haskell/.lib/haskell.so" }
)
vim.treesitter.language.register('haskell', { 'hs' })
vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = {'*.hs'},
    callback = function(_)
        vim.treesitter.start()
    end
})

