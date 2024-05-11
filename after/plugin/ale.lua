vim.cmd([[
let g:ale_linters = {
\   'proto': ['buf-lint'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

let g:ale_fixers = {
\   'proto': ['buf-format'],
\}
let g:ale_fix_on_save = 1
]])
