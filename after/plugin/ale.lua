vim.cmd([[
let g:ale_linters = {
\   'proto': ['buf-lint'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

let g:ale_fixers = {
\}
let g:ale_fix_on_save = 1
]])
-- \   'proto': ['buf-format'],

