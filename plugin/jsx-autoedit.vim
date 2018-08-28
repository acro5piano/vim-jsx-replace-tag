function! IsSelfCloseTag()
  let l:line_number = line(".")
  let l:line = getline(".")
  let l:tag_name = matchstr(matchstr(line, "<\\w\\+"), "\\w\\+")

  exec "normal! 0f<vat\<esc>"

  cal cursor(line_number, 1)

  let l:selected_text = join(getline(getpos("'<")[1], getpos("'>")[1]))

  let l:match_tag = matchstr(matchstr(selected_text, "</\\w\\+>*$"), "\\w\\+")

  return tag_name != match_tag
endfunction

function! SelectTag()
  if IsSelfCloseTag()
    exec "normal! \<esc>0f<v/\\/>$\<cr>l"
  else
    exec "normal! \<esc>0f<vat"
  end
endfunction

function! JSXChangeTag(new_tag)
  let l:previous_q_reg = @q
  let l:self_close_tag = IsSelfCloseTag()

  call SelectTag()

  normal! "qd

  if self_close_tag
    let @q = substitute(getreg("q"), "^<\\w\\+", ("<" . a:new_tag), "g")
  else
    let @q = substitute(getreg("q"), "^<\\w\\+", ('<' . a:new_tag), "g")
    let @q = substitute(getreg("q"), "\\w\\+>$", (a:new_tag . '>'), "g")
  end

  normal! "qp

  let @q = previous_q_reg
endfunction

" function!

function! ChangeTagPrompt(new_tag)
  let l:keycode = getchar()
  if keycode == 13 || keycode == 27
    return
  endif
  let l:user_input_tag = a:new_tag.nr2char(keycode)
  call JSXChangeTag(user_input_tag)
  redraw
  sleep 100m
  call ChangeTagPrompt(user_input_tag)
endfunction

command! JSXReplaceTag call JSXChangeTagPrompt('')
