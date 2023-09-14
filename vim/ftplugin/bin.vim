" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
  au BufReadPre  *.rom let &bin=1
  au BufReadPost *.rom if &bin | %!xxd
  au BufReadPost *.rom set ft=xxd | endif
  au BufWritePre *.rom if &bin | %!xxd -r
  au BufWritePre *.rom endif
  au BufWritePost *.rom if &bin | %!xxd
  au BufWritePost *.rom set nomod | endif

augroup END
