" init vimtex
let s:tex_vim_path = expand('<sfile>:p:h') . '/tex.vim'
exec "source " . s:tex_vim_path

if exists("g:loaded_mdvimtex")
  finish
endif
let g:loaded_mdvimtex = 1

let s:save_cpo = &cpo
set cpo&vim

" default setting
let s:mdvimtex_config = {
      \"tex_path":'expand("%:r").".tex"',
      \"open_tex":0,
      \"open_tex_cmd":'botright 5sp',
      \"continuous":1,
      \"nmap":[],
      \}
let g:mdvimtex_config = get(g:, 'mdvimtex_config', s:mdvimtex_config)

for key in keys(s:mdvimtex_config)
  if !has_key(g:mdvimtex_config, key)
    let g:mdvimtex_config[key] = s:mdvimtex_config[key]
  endif
endfor
unlet s:mdvimtex_config

command! MdVimtexCompile    call mdvimtex#mdvimtex()
command! MdVimtexUpdateTex  call mdvimtex#update_tex()

nnoremap <Plug>(mdvimtex_compile)    :<C-U>MdVimtexCompile<CR>
nnoremap <Plug>(mdvimtex_update_tex) :<C-U>MdVimtexUpdateTex<CR>

for mapping in g:mdvimtex_config["nmap"]
  let key = split(mapping, " ")[0]
  try
    exec "unmap " . key
  catch
    exec "unmap <buffer> " . key
  endtry
  exec "nmap " . mapping
endfor

let &cpo = s:save_cpo
unlet s:save_cpo
