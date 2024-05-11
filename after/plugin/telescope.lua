local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- only files in git
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- search function
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- seems useful
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
