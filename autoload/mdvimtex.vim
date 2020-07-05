let s:save_cpo = &cpo
set cpo&vim

python3 import vim
py3file <sfile>:h:h/src/mdvimtex.py
function! mdvimtex#mdvimtex()
  let l:kwargs = deepcopy(g:mdvimtex_config)
  python3 update_tex(**vim.eval('l:kwargs'))
  if !exists("b:vimtex_main")
    let b:vimtex_main = eval(l:kwargs["tex_path"])
    VimtexReloadState " apply change to vimtex
  endif
  VimtexCompile " toggle compilation
endfunction

function! mdvimtex#update()
  let l:kwargs = deepcopy(g:mdvimtex_config)
  python3 update_tex(**vim.eval('l:kwargs'))
endfunction

let s:continuous_state = 0

function! mdvimtex#update_continuous()
  if s:continuous_state == 0
    autocmd BufWritePost <buffer> MdVimtexUpdate
    let s:continuous_state = 1
  else
    autocmd! BufWritePost <buffer>
    let s:continuous_state = 0
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
