-- vim.opt.shell = "C:/msys64/usr/bin/bash"
-- vim.opt.shellcmdflag = "-c"
-- vim.opt.shellxquote="("
-- vim.opt.shellslash = true

vim.opt.shell = 'cmd.exe'
vim.opt.shellcmdflag = '/c powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned'
vim.opt.shellquote = '\"'
vim.opt.shellxquote = ''
vim.opt.shellpipe = ">"
vim.opt.shellredir = ">"

require("isaacph.remap")
require("isaacph.lazy")
require("isaacph.set")
require("isaacph.lily")
