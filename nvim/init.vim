" *** Inspited by https://github.com/prlz77/nvim *** 

" *** Fixes *** "
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0 "Solves the garbage chars problem.
let $VTE_VERSION="100"
set guicursor=

source $HOME/.config/env_setup/nvim/config/plugins.vim

" *** General *** "
set number              " show line numbers
set number relativenumber
set showcmd             " show command in bottom bar
set showmode            " show current mode
set ruler
set colorcolumn=80
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set foldenable          " enable folding
set autoread            " detect file changes

colorscheme OceanicNext

set clipboard=unnamedplus " clipboard

" *** Code *** "
syntax on
syntax enable

" *** Search ***
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
set laststatus=2


"autocompletion settings
set completeopt=menuone,noinsert

" *** Indentation ***"
filetype plugin indent on      " load filetype-specific indent files
set expandtab " tabs are spaces
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4
set smarttab

"Enable folding
set foldmethod=indent
set foldlevel=99

"Bold and italic fonts
let g:enable_bold_font = 1
let g:enable_italic_font = 1


"Remaps
"Enable folding with the spacebar
nnoremap <space> za
"foldall
nnoremap zM zm
"openall
nnoremap zR zr

"easier moving of code blocks
vnoremap < <gv
vnorema  > >gv

" resize horzontal split window
nmap <Up> <C-W>-<C-W>-
nmap <Down> <C-W>+<C-W>+
"resize vertical split window
nmap <Left> <C-W>><C-W>>
nmap <Right> <C-W><<C-W><
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"insert breakpoints
map <C-b> Oimport ipbd; ipbd.set_trace()  # BREAKPOINT<C-c>

"No highlight on search
set nohlsearch

"Remove all trailing whitespace by pressing F5
noremap <silent><F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"remap escape to Caps_Lock
au VimEnter * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

" *** Backups *** "
set undodir=~/.config/nvim/undodir
set undofile
set undolevels=700
set history=700
set undoreload=1000

set backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/backup

" *** Custom Functions ***

"Better navigating through completion list
function! Omnnipopup(action)
    if pumvisible()
        if a:action == 'tab'
            return "\<C-N>"
        endif
    endif
    return a:action
endfunction

inoremap <expr><silent><Tab> (pumvisible() ? '<C-R>=Omnnipopup("Tab")<CR>':'<Tab>')

"Deploy configuration
function! Deploy(server, port, ...)
    "level -> (level 1: sync current_dir, level 2: sync parent_dir, ...)
    let arg1 = get(a:, 1, 1) "default level=1
    let path = "/".join(split(expand('%:p'), '/')[0:-(arg1+1)], '/').'/'
    let port = "'-e ssh -p'".a:port." "
    let rsync = "\"mkdir -p ".path." && rsync\" "
    execute "!rsync -arh --delete --exclude=.git/ ".port."--progress --rsync-path=".rsync path.' '.a:server.':'.path
endfunction

"Ip autcompletion from frequent servers
function! IpCompletion(A, L, P)
    "Uncomment the following line and replace IP and P with server's IP and Port
    "let trustedips = ['IP_1, P_1', 'IP_2, P_2', 'IP_n, P_n']
    return filter(trustedips, 'v:val =~ "^'.a:A.'"')
endfunction

augroup showgraph
    au!
    autocmd User NeomakeFinished call Graph()
augroup END

"Run this after using the graph: option on the Profiler function
function! Graph()
    execute "!display pycallgraph.png"
    call feedkeys("\<CR>")
endfunction
    
"Cprofiler function
function! Profiler(file, ...)
    "profiler mode (graph:execution graph and time, mem: lots of stuff, plain: just cprofile output)
    let arg1 = get(a:, 1, "mem") "default mode
    if arg1 == "graph"
        call neomake#Sh("pycallgraph --max-depth=4 -v graphviz -- ".a:file, function('Graph'))
    elseif arg1 == "mem"
         call neomake#Sh("vprof -c cmhp ".a:file)
    endif
endfunction

"create Sync command to deploy
command! -complete=customlist,IpCompletion -nargs=+ Sync call Deploy(<f-args>)

"run cProfile on file
command! -complete=file -nargs=+ Profile call Profiler(<f-args>)

command! Lint execute "PymodeLintAuto"

