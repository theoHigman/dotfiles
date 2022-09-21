set smarttab
set smartindent
set autoindent
set clipboard=unnamedplus
set showmatch
set matchtime=3
set number
set relativenumber


call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'ackyshake/VimCompletesMe'
Plug 'vim-airline/vim-airline'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'svermeulen/vimpeccable'
Plug 'jiangmiao/auto-pairs'

call plug#end()
colorscheme gruvbox

imap qn <Esc>

let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = ' '
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ' '

echom "No Microsoft, I do not agree to your terms of service."
