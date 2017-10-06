""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My vimRC file
"
" Author: Nicolas Iderhoff
" Last Change: 2017-10-05
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Reset bug?
filetype off

syntax on

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" load pathogen + plugins
execute pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use vim settings rather than vi
set nocompatible

" combat slow vim start
" set clipboard=exclude:.*

" enable utf-8 if possible
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    " setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark
" colorscheme hybrid


let g:onedark_termcolors=256
colorscheme onedark

" let base16colorspace=256
" colorscheme base16-ocean

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost
"$TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more
"information.)
if (empty($TMUX))
    if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4
    "< https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799
    "< https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option)
    "< https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
        set termguicolors
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('gui_running')
    set go-=m
    set go-=T
    set go-=L
    set go-=r
    set lines=60 columns=1308 linespace=0
    if has('gui_win32')
        set guifont=Hack:h08
    endif
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont=Source\ Code\ Pro\ for\ Powerline:h12
    endif
endif

" change cursor in insert mode in terminal
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" display
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" show current position
set ruler

" show linenumbers
set number
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" highlight current line
set cursorline
" show matching brackets when text indicator is over them
set showmatch
" always display status line
set laststatus=2
set showtabline=2
" display incomplete commands
set showcmd

" show whitespace
" set list
" set listchars=tab:\|\

" highlight everything that goes beyond 80 columns
augroup vimrc_autocmds
    autocmd BufEnter * highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    autocmd BufEnter * match OverLength /\%81v.\+/
augroup END

" highlight 81st column in blue
highlight ColorColumn ctermbg=grey
set colorcolumn=81

" show encoding+bomb in status line
if has("statusline")
    set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" behaviour
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" don't always go to the beginning of the last line
set nostartofline

" backspace text that is already there
set backspace=indent,eol,start

" always set autoindenting on
set autoindent
set smartindent
set smarttab
set shiftround

" tabs
autocmd BufEnter * set tabstop=4|set shiftwidth=4|set expandtab|set softtabstop=4
" autocmd FileType tex set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2

" highlight search results
set hlsearch
" do incremental searching
set incsearch
" First search for the current directory containing the current file, then the
" current directory, then each directory under the current directory
" set path=.,,**

" ignore case when searching except when using capital letters
set ignorecase
set smartcase

" ????
set timeoutlen=1000 ttimeoutlen=10

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " disable automatic comment insertion
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!
        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position
        " Don't do it when the position is invalid or when inside an event
        " handler (happens when dropping a file on gvim).
        " Also don't do it when the mrak is in the first line, that is the
        " default position when opening a file.
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
    augroup END
endif " has("autocmd")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" backups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use versions instead of backup file
if has("vms")
    set nobackup
else
    set backup
endif

set nowb
set noswapfile

" stop vim from creating backup files all over the place
if has("win32")
    set backupdir=~/vimfiles/tmp
    set directory=~/vimfiles/tmp
else
  if has("unix")
    set backupdir=~/.vim/tmp
    set directory=~/.vim/tmp
  endif
endif

" keep 50 lines of command history
set history=50

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" movement + mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enable mouse if it's working
if has('mouse')
    set mouse=a
endif

" new mapleader
let mapleader=","
let g:mapleader=","

" on some keyboards this is faster than hitting Esc
:imap ;; <Esc>

" disable arrow keys so you get used to using proper hjkl
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" do not use ex mode, use q for formatting
map Q gq

" ctrl-u in insert mode deletes A LOT. use ctrl-G u to first break undo,
" so that you can undo ctrl-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenient command to see the difference between current buffer and the file
" it was loaded from, i.e. show the changes you made
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" plugin:nerdtree
" automatically open NERDTree + switch to right pane
" au VimEnter * NERDTree | wincmd p
" always show bookmakrs in tree
let NERDTreeShowBookmarks=1
" NERDTree hotkey
map <leader>& :NERDTreeToggle<CR>

" plugin:indentLine
let g:indentLine_enabled = 1
" let g:indentLine_color_term = 239
let g:indentLine_color_term = 19
" let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_tty_light = 7
let g:indentLine_color_dark = 1
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_char = '|'

" plugin:vim-airline
" fix for: vim-airline doesn't appear until I create a new split
if exists("g:airline_powerline_fonts")
    let g:airline_powerline_fonts = 1
endif

" plugin:vim-r-plugin
" let vimrplugin_applescript = 0
" let vimplugin_vimpager = \"no"
" let g:ScreenImpl = 'Tmux'
" send selection to R
" vmap <Space> <Plug>RDSendSelection
" send line to R
" nmap <Space> <Plug>RDSendLine
" start R Plugin
" map <F2> <Plug>RStart
" imap <F2> <Plug>RStart
" vmpa <F2> <Plug>Rstart

" plugin:vim-latex
" if has("unix") && match(system("uname"),'Darwin') != -1
" let g:Tex_GotoError=0
" let g:Tex_TreatMacViewerAsUNIX=1
" let g:Tex_ExecuteUNIXViewerInForeground=1
" let g:Tex_ViewRule_pdf = 'open -a Preview.app'
" endif
" let g:Tex_BibtexFlavor = 'biber'

" plugin:vim-markdown
" Disable vim instant markdown preview from autostarting
let g:instant_markdown_autostart = 0
" Disable folding in vim markdown plugin
let g:vim_markdown_folding_disabled=1


