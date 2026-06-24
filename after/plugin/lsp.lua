local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-x><C-o>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-a>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        -- remove useless junk from lsp recommendations
        {
            name = 'nvim_lsp',
            entry_filter = function(entry, _)
                return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind() and
                    require('cmp').lsp.CompletionItemKind.Snippet ~= entry:get_kind() and
                    require('cmp').lsp.CompletionItemKind.Keyword ~= entry:get_kind()
            end
        },
    }),
    completion = {
        autocomplete = false,
    },
})


-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
--     }, {
--         { name = 'buffer' },
--     })
-- })

-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     -- mappings don't work?
--     mapping = cmp.mapping.preset.cmdline({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.abort(),
--         ['<C-Enter>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     }),
--     sources = {
--         { name = 'buffer' }
--     }
-- })
-- 
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     -- mappings don't work?
--     mapping = cmp.mapping.preset.cmdline({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.abort(),
--         ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
--     }),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
cmp_capabilities.textDocument.completion.completionItem.snippetSupport = false

-- default lua ls config
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })

            client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end,
    capabilites = cmp_capabilities,
})

vim.lsp.enable('clangd')
vim.lsp.config('clangd', {
    capabilities = cmp_capabilities,
    filetypes = {
        "c", "cpp", "objc", "objcpp", "cuda"-- , "proto"
    },
})
vim.lsp.enable('zls')
vim.lsp.config('zls', {
    capabilities = cmp_capabilities,
})
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
    capabilities = cmp_capabilities,
})
vim.lsp.enable('hls')
vim.lsp.config('hls', {
    capabilities = cmp_capabilities,
    cmd = { 'haskell-language-server-9.12.2', '--lsp', },
})

local lsp_attach = function(event)
    local opts = {buffer = event.buf, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    vim.highlight.priorities.semantic_tokens = 95
end
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = lsp_attach
})



-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- require('mason').setup()

-- local servers = {
--     rust_analyzer = {
--         ["rust-analyzer"] = {
--             cargo = {
--                 allFeatures = true,
--             },
--         }
--     },
-- };
-- 
-- require('mason-lspconfig').setup({
--     ensure_installed = vim.tbl_keys(servers),
-- })
-- 
-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local lsp_attach = function(client, bufnr)
--     local opts = {buffer = bufnr, remap = false}
--     vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--     vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--     vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--     vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--     vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
--     vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
--     vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--     vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
--     vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--     vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- 
--     -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
--     local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
--     for i, v in ipairs(tokenModifiers) do
--       tmp = string.gsub(v, ' ', '_')
--       tokenModifiers[i] = string.gsub(tmp, '-_', '')
--     end
--     local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
--     for i, v in ipairs(tokenTypes) do
--       tmp = string.gsub(v, ' ', '_')
--       tokenTypes[i] = string.gsub(tmp, '-_', '')
--     end
-- end
-- 
-- local lspconfig = require('lspconfig')
-- require('mason-lspconfig').setup_handlers({
--     function(server_name)
--         local settings = {};
--         if servers[server_name] ~= nil then
--             settings = servers[server_name]
--         end
--         lspconfig[server_name].setup({
--             on_attach = lsp_attach,
--             capabilities = lsp_capabilities,
--             settings = settings,
--         })
--     end,
-- })
-- 
-- local cmp = require('cmp')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- cmp.setup({
--     snippet = {
--         expand = function(args)
--             vim.fn["vsnip#anonymous"](args.body)
--         end,
--     },
--     window = {
--     },
--     mapping = cmp.mapping.preset.insert({
--         ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--         ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--         ['<CR>'] = vim.NIL,
--         ['<Up>'] = cmp.mapping.scroll_docs(-4),
--         ['<Down>'] = cmp.mapping.scroll_docs(4),
--     }),
--     sources = cmp.config.sources({
--         { name = 'nvim_lsp' },
--         { name = 'vsnip' },
--     }, {
--         { name = 'buffer' },
--     })
-- })
-- 
-- vim.diagnostic.config({
--     virtual_text = false,
--     severity_sort = true,
--     float = {
--         source = "always",
--         border = "single",
--     },
-- })

-- 
-- -- Learn the keybindings, see :help lsp-zero-keybindings
-- -- Learn to configure LSP servers, see :help lsp-zero-api-showcase
-- local lsp = require('lsp-zero')
-- 
-- -- (Optional) Configure lua language server for neovim
-- -- lsp.nvim_workspace()
-- 
-- lsp.preset('recommended')
-- 
-- lsp.ensure_installed({
-- 	'rust_analyzer',
-- 	'sumneko_lua',
-- })
-- 
-- local cmp = require('cmp')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- 	['<C-Space>'] = cmp.mapping.complete(),
--     ['<CR>'] = vim.NIL,
-- })
-- 
-- lsp.set_preferences({
-- 	sign_icons = {} })
-- 
-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings
-- })
-- 
-- lsp.on_attach(function(client, bufnr)
-- 	local opts = {buffer = bufnr, remap = false}
-- 	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
-- 	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
-- 	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
-- 	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
-- 	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
-- 	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
-- 	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
-- 	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
-- 	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
-- 	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- end)
-- 
-- -- lsp.skip_server_setup({'omnisharp'})
-- lsp.setup()
-- 
-- -- special unity stuff
-- 
-- -- local nvim_lsp = require'lspconfig'
-- -- local pid = vim.fn.getpid()
-- -- local omnisharp_bin = "/opt/Unity/omnisharp/run"
-- -- require'lspconfig'.omnisharp.setup{
-- --     cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
-- --     root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln");
-- --     ...
-- -- }
-- -- 
