vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- allow to move visually selected line up and down in syntax
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append line below with a space, and don't pan screen to the right
vim.keymap.set("n", "J", "mzJ`z")

-- half-page jump stay centered
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- delete highlighted word into void register and keep clipboard during paste
vim.keymap.set("v", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("x", "<leader>d", "\"_d")

-- make capital Y go to the end of the line
vim.keymap.set("n", "Y", "yg$")

-- leader y yanks into system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")

-- uhh no tmux thing for now plz

-- is this the same as '='?
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- quick fix navigation?
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- we don't need find/replace with our lsp rename function

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("i", "<C-x><C-x>f", function()
--     local file = vim.api.nvim_eval("@%")
--     -- from last / to last .
--     for c in file:
--         if c == '/':
--             print('hi')
--     end
-- end)

-- Pressing ; will now act like : (enter command mode)
vim.keymap.set({'n', 'v'}, ';', ':')

-- Pressing : will now act like ; (repeat last f, F, t, or T movement)
vim.keymap.set({'n', 'v'}, ':', ';')
