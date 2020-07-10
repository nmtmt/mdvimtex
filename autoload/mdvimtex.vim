let s:save_cpo = &cpo
set cpo&vim

python3 import vim
py3file <sfile>:h:h/src/mdvimtex.py

" force reset tex file variable
function! mdvimtex#reset()
  call mdvimtex#update_continuous(0)
  let l:kwargs = deepcopy(g:mdvimtex_config)
  echo "Overwrite b:vimtex_main variable to " . l:kwargs["tex_path"]
  let b:vimtex_main = eval(l:kwargs["tex_path"])
  VimtexReloadState " tell vimtex the change
endfunction

" set tex file variable and tell vimtex
function! mdvimtex#init(kwargs)
  if !exists("b:vimtex_main")
    let b:vimtex_main = eval(a:kwargs["tex_path"])
    VimtexReloadState " tell vimtex the change
  endif
endfunction

 " toggle md compilation with vimtex
function! mdvimtex#mdvimtex()
  let l:kwargs = mdvimtex#update_tex()
  call mdvimtex#init(l:kwargs)

  if g:vimtex_compiler_latexmk["continuous"]
    call mdvimtex#sync_vimtex_compiler(1)
  else
    call mdvimtex#sync_vimtex_compiler(0)
  endif
  VimtexCompile " toggle compilation of tex file
endfunction

function! mdvimtex#update_tex()
  let l:kwargs = deepcopy(g:mdvimtex_config)
  python3 update_tex(**vim.eval('l:kwargs'))
  return l:kwargs
endfunction

function! mdvimtex#sync_vimtex_compiler(sync_flag)
  if a:sync_flag == 1
    autocmd User VimtexEventCompileStarted call mdvimtex#update_continuous(1)
    autocmd User VimtexEventCompileStopped call mdvimtex#update_continuous(0)
  else
    autocmd! User VimtexEventCompileStarted
    autocmd! User VimtexEventCompileStopped
  endif
endfunction

function! mdvimtex#update_continuous(continuous_flag)
  if a:continuous_flag == 1
    autocmd BufWritePost <buffer> MdVimtexUpdate
  else
    autocmd! BufWritePost <buffer>
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
