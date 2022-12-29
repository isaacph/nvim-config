
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['rust_analyzer'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        features = {
            "client", "server",
        }
      }
    }
  }
}
require'lspconfig'.omnisharp.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(_, bufnr)
    local builtin = require('telescope.builtin')
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', '<leader>fu', builtin.lsp_references, {})
    vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, {})
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>dn', vim.lsp.diagnostic.goto_next, {})
    vim.keymap.set('n', '<leader>dN', vim.lsp.diagnostic.goto_prev, {})
    vim.keymap.set('n', '<leader>dN', vim.lsp.buf.hover, {})
    vim.keymap.set('n', '<leader>dd', builtin.diagnostics, {})
    -- nnoremap('<leader>dD', 'Telescope lsp_workspace_diagnostics')
    vim.keymap.set('n', '<leader>xx', vim.lsp.buf.code_action, {})
    vim.keymap.set('n', '<leader>xd', vim.lsp.buf.range_code_action, {})
  end,
  cmd = { "omnisharp", "--languageserver" , "--hostPID", tostring(pid) },
}

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    -- ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-a>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
--     { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
--     { name = 'buffer', keyword_length = 2 },        -- source current buffer
--     { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Vim config --
vim.cmd([[
set ts=4
set sw=4
set expandtab
set nonumber
colorscheme moonfly
]])

-- local rt = require("rust-tools")
-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       local bufopts = { noremap=true, silent=true, buffer=bufnr }
--       -- Hover actions
--       vim.keymap.set("n", "gA", rt.hover_actions.hover_actions, bufopts)
--       -- Code action groups
--       vim.keymap.set("n", "gS", rt.code_action_group.code_action_group, bufopts)
-- 
--       local bufopts = { noremap=true, silent=true, buffer=bufnr }
--       vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
--       vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
--       vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
--       vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
--       vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
--       vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
--       vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
--       vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
--       vim.keymap.set("n", "<space>f", vim.lsp.buf.code_action, bufopts)
--       vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--     end,
--     settings = {
--       ["rust-analyzer"] = {
--         cargo = {
--           features = {
--             "client",
--             "server"
--           }
--         }
--       }
--     }
--   },
-- })
-- rt.inlay_hints.disable()

vim.cmd [[au BufRead,BufNewFile *.wgsl	set filetype=wgsl]]

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.wgsl = {
    install_info = {
        url = "https://github.com/szebniok/tree-sitter-wgsl",
        files = {"src/parser.c"}
    },
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"wgsl"},
    highlight = {
        enable = true
    },
}

