function! JSXIsSelfCloseTag()
  let l:line_number = line(".")
  let l:line = getline(".")
  let l:tag_name = matchstr(matchstr(line, "<\\w\\+"), "\\w\\+")

  exec "normal! 0f<vat\<esc>"

  call cursor(line_number, 1)

  let l:selected_text = join(getline(getpos("'<")[1], getpos("'>")[1]))

  let l:match_tag = matchstr(matchstr(selected_text, "</\\w\\+>*$"), "\\w\\+")

  return tag_name != match_tag
endfunction

function! JSXSelectTag()
  if JSXIsSelfCloseTag()
    exec "normal! \<esc>0f<v/\\/>$\<cr>l"
  else
    exec "normal! \<esc>0f<vat"
  end
endfunction

function! JSXChangeTag(new_tag)
  silent! undojoin
  let l:previous_q_reg = @q
  let l:self_close_tag = JSXIsSelfCloseTag()
  let l:safe_new_tag = a:new_tag == "" ? "_" : a:new_tag

  call JSXSelectTag()

  silent! normal! "qd

  if self_close_tag
    let @q = substitute(getreg("q"), "^<\\w\\+", ("<" . safe_new_tag), "g")
  else
    let @q = substitute(getreg("q"), "^<\\w\\+", ('<' . safe_new_tag), "g")
    let @q = substitute(getreg("q"), "\\w\\+>$", (safe_new_tag . '>'), "g")
  end

  silent! normal! "qp

  let @q = previous_q_reg
endfunction

function! JSXSaveUndo()
  let l:previous_q_reg = @q
  call JSXSelectTag()
  silent! normal! "qy
	let s:previous_content = getreg("q")
  let @q = previous_q_reg
endfunction

function! JSXCancel()
  call JSXSelectTag()
  silent! normal! "qd
  let @q = s:previous_content
  silent! normal! "qp
endfunction

function! JSXChangeTagPrompt(new_tag, is_first_run)
  if a:is_first_run
    call JSXSaveUndo()
  endif

  let l:keycode = getchar()

  if keycode == 27 " Escape
    echo 'Canceled.'
    call JSXCancel()
    return
  endif

  if keycode == 13 " Return
    return
  endif

  let l:user_input_tag = ''
  if keycode == 8 || keycode == "\<BS>"
    let l:user_input_tag = a:new_tag[:-2]
  else
    let l:user_input_tag = a:new_tag.nr2char(keycode)
  endif
  call JSXChangeTag(user_input_tag)
  redraw
  call JSXChangeTagPrompt(user_input_tag, 0)
endfunction

command! JSXReplaceTag call JSXChangeTagPrompt('', 1)
