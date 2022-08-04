filetype plugin indent on

" Can use backspace in insert mode, even for text entered in another
" session.
set backspace=indent,eol,start

" Expands tabs into spaces with width 4.
set expandtab
set tabstop=4
set shiftwidth=4

" Allows backspace to erase an entire tab character.
set softtabstop=4

" Shows the cursor position in the status bar at the bottom of the window.
set ruler

" Performs searches as soon as you start typing.
set incsearch

" Highlights search matches.
set hlsearch

" Shows line numbers.
set number

" Highlights the current line.
set cursorline

" Turn on modeline
set modeline

" Maps j and k to move between wrapped lines (instead of between lines
" separated by newline characters).
noremap j gj
noremap k gk

" Alternative escape sequence.
imap jk <Esc>

" Fast tab switching
noremap gh gT
noremap gl gt

" Change/delete inner words
noremap cw ciw
noremap dw diw

" Word count for LaTeX documents
map ww :w !detex \| wc -w<CR>

" Write and make in a single command
map mm :w<CR>:!make<CR>

" Disables tab expansion for Makefiles, since they require tab characters.
autocmd FileType make setlocal noexpandtab

" Enables spell checking for certain filetypes.
autocmd FileType tex setlocal spell spelllang=en_us
autocmd FileType xhtml setlocal spell spelllang=en_us

" Strips the trailing whitespaces (especially useful for git!).
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Saves the cursor position, etc. as viminfo and restores it for each
" session.
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Long line highlighting; highlights in red for characters past column 80.
" This function checks against a blacklist of filetypes because text file
" types will often have long lines that we don't really want to highlight.
fun! HighlightLongLines()
    " Specify multiple of these with fmt\|fmt\|fmt
    if &ft =~ 'tex'
        return
    endif
    let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endfun

autocmd BufWinEnter * call HighlightLongLines()

" Search highlighting will be cleared with single return.
nnoremap <CR> :nohlsearch<CR>/<BS><CR>

" Fix terminal colors after quitting Vim
autocmd VimLeave * !echo -ne "\033[0m"

" Load the package manager
execute pathogen#infect()

" Always show airline statusline
set laststatus=2
set encoding=utf-8
set ambiwidth=single
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Markdown fenced blocks
let g:markdown_fenced_languages = ['bash=sh', 'css', 'javascript', 'js=javascript', 'json=javascript', 'php', 'python', 'sass', 'xml', 'html']

" Syntax highlighting
syntax enable
set background=dark

if $STY != ""
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color GNU screen.
    set t_ut=
    set t_Co=256
    let g:airline_theme='atomic'
    colorscheme hybrid
else
    set termguicolors
    let g:nord_italic = 1
    let g:nord_underline = 1
    let g:nord_italic_comments = 1
    let g:nord_cursor_line_number_background = 1
    let g:airline_theme='nord'
    colorscheme nord
endif

" Highlight TODO, FIXME, NOTE, etc.
let g:todo_color = synIDattr(hlID('Todo'), 'fg')
execute printf('highlight FancyTodo guifg=%s cterm=italic', g:todo_color)
autocmd Syntax * call matchadd('FancyTodo', '\W\zs\(TODO\|FIXME\|NOTE\|XXX\|BUG\|HACK\)')
autocmd Syntax * call matchadd('FancyTodo', '\W\zs\(TODO\|FIXME\|NOTE\|XXX\|BUG\|HACK\):')

" vim: set ft=vim:
