" rtf_highlight.vim
" Vagmi Mudumbai <vagmi at dharanasoft dot com>
" License
" This program is free software. It comes without any warranty, to
" the extent permitted by applicable law. You can redistribute it
" and/or modify it under the terms of the Do What The Fuck You Want
" To Public License, Version 2, as published by Sam Hocevar. See
" http://sam.zoy.org/wtfpl/COPYING for more details. */



" This plugin uses the bad ass RTF Syntax Highlighter aptly titled 'highlight'
" Get highlight from http://www.andre-simon.de/doku/highlight/en/highlight.html

" setup a few variables
if !exists('g:rtfh_theme')
  let g:rtfh_theme = 'bipolar'
end
if !exists('g:rtfh_font')
  let g:rtfh_font = 'Menlo'
end
if !exists('g:rtfh_size')
  let g:rtfh_size = '24'
end

if !exists('g:rtfh_clipboard')
    let g:rtfh_clipboard = 'pbcopy'
endif

let s:alias_dict = {
            \ 'javascript' : 'js',
            \}

" the awesomeness
function! RTFHighlight(line1,line2,...)
  if !executable('highlight')
    echoerr "Bummer! highlight not found."
    return
  endif

  " default to use the filetype as the syntax
  let filetype_aliased = &filetype

  if exists("a:1")
      " if the user explicitly set a syntax with the argument, use that.
      let filetype_aliased = a:1
  elseif has_key(s:alias_dict, &filetype)
      " if there's a known alias for the filetype, use that.
      let filetype_aliased = s:alias_dict[&filetype]
  endif

  let command = "highlight --syntax=" . filetype_aliased 
              \. " -s " . g:rtfh_theme 
              \. " -k " . g:rtfh_font 
              \. " -K " . g:rtfh_size 
              \. " -O rtf "
              \. "| " . g:rtfh_clipboard

  let content = join(getline(a:line1,a:line2),"\n")

  let output = system(command,content)
  " let @* = output
  " for some reason text copied this way
  " gets pasted as escaped plain text in keynote
  " but this works well with pbcopy
  " let retval = system("pbcopy",output)
endfunction

" map it to a command
command! -nargs=? -range=% RTFHighlight :call RTFHighlight(<line1>,<line2>,<f-args>)
