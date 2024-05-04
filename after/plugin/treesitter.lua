require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  -- ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "vim" },

  -- -- Install parsers synchronously (only applied to `ensure_installed`)
  -- sync_install = false,

  -- -- Automatically install missing parsers when entering buffer
  -- -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  -- auto_install = true,

  -- highlight = {
  --   -- `false` will disable the whole extension
  --   enable = true,

  --   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  --   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  --   -- Using this option may slow down your editor, and you may see some duplicate highlights.
  --   -- Instead of true it can also be a list of languages
  --   additional_vim_regex_highlighting = false,
  -- },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = '<CR>',
  --     scope_incremental = '<CR>',
  --     node_incremental = '<TAB>',
  --     node_decremental = '<S-TAB>',
  --   },
  -- },
}
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.asm = {
    install_info = {
        url = 'https://github.com/rush-rs/tree-sitter-asm.git',
        files = { 'src\\parser.c' },
        branch = 'main',
    },
}
parser_config.glsl_custom = {
    install_info = {
        url = "C:/workplace/tree-sitter-glsl",
        files = {"src/parser.c"},
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
    },
    filetype = "glsl_custom",
}
vim.treesitter.language.register('glsl_custom', 'glsl')
vim.treesitter.language.register('glsl_custom', 'vert')
vim.treesitter.language.register('glsl_custom', 'frag')
