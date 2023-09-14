call ale#linter#Define('go', {
\   'name': 'revive',
\   'output_stream': 'both',
\   'executable': 'revive',
\   'read_buffer': 0,
\   'command': 'revive %t',
\   'callback': 'ale#handlers#unix#HandleAsWarning',
\})

lua <<EOF
require('go').setup()
EOF

autocmd BufWritePre * GoFmt

let b:ale_linters = {'go': ['revive']}
let b:ale_fixers = {'go': ['gofmt']}
let g:ale_fix_on_save = 1

" CocDisable
ALEEnable
