# vim-jsx-replace-tag

a Vim plugin to replace jsx tag with interactive UI.

# Demo


![](https://github.com/acro5piano/jsx-autoedit/blob/master/demo.gif)

# Install

```
Plug 'acro5piano/vim-jsx-replace-tag'
```

# Usage

- Run `:JSXReplaceTag` where cursor is the same line of the tag to edit.
- Input new tag name then press Return key
- You can cancel editing with `<ESC>`

# Example setting

In your `.vimrc`,

```vim
nnoremap <Leader>rt :JSXReplaceTag<CR>
```

# Thanks

A lot of code was ported from `vim-jsx-utils`. Really thanks!

https://github.com/samuelsimoes/vim-jsx-utils
