-- local cmp = require'cmp'.setup {
--     snippet = {
--         expand = function(args)
--             require 'luasnip'.lsp_expand(args.body)
--         end
--     },
--     mapping = cmp.mapping.preset.insert({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.abort(),
--         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--     }),
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--     },
-- }
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = {}

function Global_set_bindings(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({
            border = "rounded",
        })
    end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
end

print("init?")
-- local lsp = require('lspconfig')
-- lsp.on_attach = (function(client, bufnr)
--     print("on attach?")
--     Global_set_bindings(client, bufnr)
-- end)
-- lsp.clangd.setup {
--     capabilities = capabilities,
--     on_attach = Global_set_bindings,
-- }
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
    on_attach = Global_set_bindings,
    -- root_dir = (function(fname)
    --   local root_files = {
    --       'Cargo.toml'
    --   }
    --   local util = require 'lspconfig.util'
    --   local x = util.root_pattern(unpack(root_files))(fname)
    --     or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    --   x = x:gsub("/", "\\")
    --   print('root:', x)
    --   return x
    -- end)
})
vim.lsp.config('lua_ls', {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        -- print("path is "..path..'/.luarc.json')
        -- if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        --     print('fs stat?')
        --     return
        -- end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'Lua 5.1',
                basic = "disable",
                debug = "disable",
                io = "disable",
                math = "disable",
                os = "disable",
                package = "disable",
                string = "disable",
                table = "disable",
                utf8 = "disable",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                -- library = {
                --     vim.env.VIMRUNTIME
                --     -- Depending on the usage, you might want to add additional paths here.
                --     -- "${3rd}/luv/library"
                --     -- "${3rd}/busted/library",
                -- },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
                library = { "C:\\workplace\\vscode-wow-api\\Annotations" }
            }
        })
    end,
    settings = {
        Lua = {}
    },
    on_attach = Global_set_bindings
})
-- local util = require('lspconfig').util
-- lsp.pylyzer.setup {
-- root_dir = function(fname)
--   local root_files = {
--     'setup.py',
--     'tox.ini',
--     'requirements.txt',
--     'Pipfile',
--     'pyproject.toml',
--   }
--   local x = util.root_pattern(unpack(root_files))(fname)
--     or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
--   x = x:gsub("\\", "/")
--   print(x)
--   return '/'
-- end,
--   cmd = { 'pylyzer', '--server' },
--   filetypes = { 'python' },
--   single_file_support = false,
--   settings = {
--     python = {
--       diagnostics = true,
--       inlayHints = true,
--       smartCompletion = true,
--       checkOnType = false,
--     },
--   },
-- }
vim.keymap.set('n', '<space>vd', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.diagnostic.config({ virtual_text = { current_line = true } })
