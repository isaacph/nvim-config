local ts_utils = require 'nvim-treesitter.ts_utils'
local parsers = require 'nvim-treesitter.parsers'

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
  incremental_selection = {
      enable = true,
      keymaps = {
          init_selection = '<CR>',
          scope_incremental = '<CR>',
          node_incremental = '<C-h>',
          node_decremental = '<C-l>',
      },
  },
  highlight = { enable = true },
  playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
      },
  }
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
vim.treesitter.language.register('glsl_custom', 'comp')
vim.treesitter.language.register('glsl_custom', 'vert')
vim.treesitter.language.register('glsl_custom', 'frag')

local level = nil
vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        level = nil
    end
})

-- we need to find the smallest node that contains vstart to vend

local function leq(ar, ac, br, bc)
    return ar < br or (ar == br and ac <= bc)
end
local function less(ar, ac, br, bc)
    return ar < br or (ar == br and ac < bc)
end
local function geq(ar, ac, br, bc)
    return ar > br or (ar == br and ac >= bc)
end
local function grtr(ar, ac, br, bc)
    return ar > br or (ar == br and ac > bc)
end

local function node_contains(node, sr, sc, er, ec)
    startr, startc, endr, endc = node:range()
    if leq(startr, startc, sr, sc) and leq(er, ec, endr, endc) then
        -- if contains then return and update selection
        return true
    end
    return false
end

local function sort(sr, sc, er, ec)
    if leq(sr, sc, er, ec) then
        return sr, sc, er, ec
    else
        return er, ec, sr, sc
    end
end

local function get_node_selected()
    local row, col = vim.api.nvim_win_get_cursor(0)
    local node = ts_utils.get_node_at_cursor()
    local vstart = vim.fn.getpos("v")
    local startr, startc = vstart[2] - 1, vstart[3] - 1
    local vend = vim.fn.getpos(".")
    -- print('inspect', vim.inspect(vstart), vim.inspect(vend))
    local endr, endc = vend[2] - 1, vend[3]
    startr, startc, endr, endc = sort(startr, startc, endr, endc)
    -- print('start', startr, startc, endr, endc)

    local buf = vim.api.nvim_win_get_buf(0)
    local root_lang_tree = parsers.get_parser(buf)
    if not root_lang_tree then
        return
    end
    -- root_lang_tree:for_each_tree(function(tree, ltree)
    --     print('tree', tree:root():range(), ltree:lang())
    -- end)

    local lang_tree = root_lang_tree:language_for_range({startr, startc, endr, endc})
    -- print('tree count', #lang_tree:trees())
    -- print('lfr', lang_tree, vim.inspect(lang_tree), lang_tree:lang())
    -- local usual_good = lang_tree:node_for_range({startr, startc, endr, endc}, {ignore_injections = false})
    local tree = lang_tree:tree_for_range({startr, startc, endr, endc}, {ignore_injections = false})

    -- start at the root and start going down
    -- print(#lang_tree:trees())
    node = tree:root()
    last_node = node
    count = 0
    while true do
        sr, sc, er, ec = node:range()
        -- print('topdown', node:type(), node:child_count(), ' - ', sr, sc, er, ec)
        count = count + 1
        if count > 100 then
            print('count 2 exceeded')
            return nil
        end
        local contained = false
        for elt in node:iter_children() do
            -- print('child', elt:type(), elt:range())
            if node_contains(elt, startr, startc, endr, endc) then
                last_node = node
                node = elt
                contained = true
                break
            end
        end
        if not contained then break end
    end
    -- print(node:type(), last_node:type())
    return node
end

vim.keymap.set("v", "<C-k>", function()
    node = get_node_selected()
    if node == nil then
        return
    end
    local next = ts_utils.get_previous_node(node, false, false)
    if next == nil then
        return
    end
    ts_utils.update_selection(0, next)
end)
vim.keymap.set("v", "<C-j>", function()
    node = get_node_selected()
    if node == nil then
        return
    end
    local next = ts_utils.get_next_node(node, false, false)
    if next == nil then
        return
    end
    ts_utils.update_selection(0, next)
end)

