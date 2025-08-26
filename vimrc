"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" make Vim behave in a more useful way
set nocompatible

" start up mouse
set mouse+=a

" set the number of spaces for a Tab 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" set auto indent 
set autoindent
set smartindent

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" don't show intro message
set shortmess+=I

" Show relative rows number
set number relativenumber

 " show current line
set cursorline

" baskspace style
set backspace=indent,eol,start

" easy for display another window
set hidden

" for search patter
set ignorecase
set smartcase
set incsearch

" Highlight search results
set hlsearch

" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>  

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

let mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" For regular expressions turn magic on
set magic

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en

set signcolumn=yes

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=.git\*,.hg\*,.svn\*

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

nnoremap gsv :so $MYVIMRC<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Syntax highlighting 
syntax on

" Set regular expression engine automatically
set regexpengine=0

"set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader><tab>] :bnext<cr>
map <leader><tab>[ :bprevious<cr>

map <leader>+ :resize +5<cr>
map <leader>_ :resize -5<cr>
map <leader>, :vertical resize -5<cr>
map <leader>. :vertical resize +5<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction



" Smart way to for windows
map <silent> <C-w>_ :sp<cr>
map <silent> <C-w>\| :vs<cr>

map <silent> <C-j> :wincmd j<cr>
map <silent> <C-k> :wincmd k<cr>
map <silent> <C-h> :wincmd h<cr>
map <silent> <C-l> :wincmd l<cr>


" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

inoremap {<CR> {<CR>}<ESC>O
inoremap " ""<ESC>i
inoremap "" ""
inoremap ( ()<ESC>i
inoremap () ()


set termguicolors

colorscheme catppuccin_mocha



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

call plug#end()

let g:lsp_diagnostics_enabled = 0
