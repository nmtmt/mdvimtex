" Load vimtex
if !get(g:, 'vimtex_enabled', 1)
  finish
endif

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

if !(!get(g:, 'vimtex_version_check', 1)
      \ || has('nvim-0.1.7')
      \ || v:version >= 704)
  echoerr 'Error: vimtex does not support your version of Vim'
  echom 'Please update to Vim 7.4 or neovim 0.1.7 or later!'
  echom 'For more info, please see :h vimtex_version_check'
  finish
endif

call vimtex#init()
" Load vimtex done

if exists("g:loaded_mdvimtex")
  finish
endif
let g:loaded_mdvimtex = 1

let s:save_cpo = &cpo
set cpo&vim

let g:mdvimtex_config = {
      \"tex_path":'expand("%:r").".tex"',
      \"open_tex":0,
      \"open_tex_cmd":'botright 5sp',
      \"continuous":1,
      \}

command! MdVimtexCompile    call mdvimtex#mdvimtex()
command! MdVimtexUpdateTex  call mdvimtex#update_tex()

nnoremap <Plug>(mdvimtex_compile)    :<C-U>MdVimtexCompile<CR>
nnoremap <Plug>(mdvimtex_update_tex) :<C-U>MdVimtexUpdateTex<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

