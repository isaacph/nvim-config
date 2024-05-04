-- vim.opt.shell = "C:/msys64/usr/bin/bash"
-- vim.opt.shellcmdflag = "-c"
-- vim.opt.shellxquote="("
-- vim.opt.shellslash = true

vim.opt.shell = 'powershell'
vim.opt.shellcmdflag = '-command'
vim.opt.shellquote = '\"'
vim.opt.shellxquote = ''

require("isaacph.remap")
require("isaacph.lazy")
require("isaacph.set")
