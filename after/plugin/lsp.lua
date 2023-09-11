local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
	'rust_analyzer',
    'lua_ls',
    'tsserver',
    'cssls',
    'html',
    'jsonls',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})

-- disable some annoying keybinds
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp_mappings['<CR>'] = nil

lsp.set_preferences({
	sign_icons = { }
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
end)

-- here add individual server setups
-- ex:
-- require('lspconfig').eslint.setup({
--   single_file_support = false,
--   on_attach = function(client, bufnr)
--     print('hello eslint')
--   end
-- })

lsp.setup()

-- here add custom servers
-- lsp.new_server({
--   name = 'asm-lsp-custom',
--   cmd = {'C:\\Users\\isaac\\Documents\\personal\\asm-lsp\\target\\debug\\asm-lsp.exe'},
--   filetypes = {'asm'},
--   root_dir = function()
--     return lsp.dir.find_first({'asmcfg'}) 
--   end
-- })
