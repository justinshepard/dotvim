" vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
"     _ ___     _       
"  _ | / __|_ _(_)_ __  
" | || \__ \ V / | '  \ 
"  \__/|___/\_/|_|_|_|_|
"
" Justin's personal vimrc
" Formatting and (some) content based on 
" Steve Francia's spf13-vim available at
" https://github.com/spf13/spf13-vim/
"

" Pathogen {
	call pathogen#infect()
	syntax on
	filetype plugin indent on
" }

" Environment {
    " Basics {
        set nocompatible
        set background=dark
        set modeline
    " }

    " Windows Compatibility {
        if has('win32') || has('win64')
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
" }

" General {
    set background=dark
    if !has('gui')
        set term=$TERM
    endif
    filetype plugin indent on
    syntax on
    scriptencoding utf-8
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set shortmess+=filmnrxoOtT
    set viewoptions=folds,options,cursor,unix,slash
    set virtualedit=onemore
    set history=1000
    set hidden

    " Set up directories {
        set backup
        if has('persistent_undo')
            set undofile
            set undolevels=1000
            set undoreload=10000
        endif
        au BufWinLeave *.* silent! mkview
        au BufWinEnter *.* silent! loadview
    " }

    " Fire up pathogen to load plugins
    call pathogen#infect()
" }

" Vim UI {
    if &term =~ "xterm"
        let &t_Co=256
    endif
    colorscheme desert256
    set tabpagemax=15
    set showmode

    if has('cmdline_info')
        set ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
        set showcmd
    endif

    if has('statusline')
        set laststatus=2

        set statusline=%<%f\ 
        set statusline+=%w%h%m%r
        set statusline+=%{fugitive#statusline()}
        set statusline+=\ [%{&ff}/%Y]
        set statusline+=\ [%{getcwd()}]
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%
    endif

	 set foldenable

    set backspace=indent,eol,start
    set linespace=0
    set number
    set incsearch
    set hlsearch
    set winminheight=0
    set ignorecase
    set smartcase
    set scrolljump=5
    set scrolloff=3
    set tabstop=3
    set shiftwidth=3
    set smarttab
    " set lbr
    " set ai
    " set si
    " set nowrap

" }

" Key (re)Mappings {

    " Change default leader to ',' instead of '\'
    let mapleader = ','

    " Make ; work like : for commands.
    nnoremap ; :

    " Wrapped lines go to next row rather than next line.
    nnoremap j gj
    nnoremap k gk

    " Fix being too fast on the shift key
    cmap W w
    cmap WQ wq
    cmap wQ wq
    cmap Q q
    cmap Tabe tabe

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
	 nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Clearing hlsearch
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Forgot to sudo? Write it anyway!
    cmap w!! w !sudo tee % >/dev/null

    " Adjust viewports to same size
    map <Leader>= <C-w>=
" }

" Functions {

" Initialize our vim metadata directories in the home folder.
function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }
