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

" Maps j and k to move between wrapped lines (instead of between lines
" separated by newline characters).
noremap j gj
noremap k gk

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
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

syntax enable
set term=screen-256color
set t_Co=256
set background=dark
colorscheme wombat256mod

" Highlight TODO, FIXME, NOTE, etc.
autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|NOTE\|XXX\|BUG\|HACK\)')
