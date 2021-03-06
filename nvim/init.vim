" 
" nvim config - https://neovim.io/
" requires:
"   - vim-plug: https://github.com/junegunn/vim-plug
"

autocmd!

set nocompatible
set termguicolors

" plugins

call plug#begin('~/.config/nvim/plugins')

Plug 'neoclide/coc.nvim', {'branch': 'release'}             " completions

Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}       " julia language support
Plug 'bfrg/vim-cpp-modern'                                  " c language support

Plug 'scrooloose/nerdtree'                                  " tree
Plug 'airblade/vim-gitgutter'                               " git integration
Plug 'tpope/vim-commentary'                                 " comments
Plug 'morhetz/gruvbox'                                      " colorscheme 

call plug#end()

" options

syntax   on
filetype on
filetype plugin on
filetype indent on

set guifont =Fira\ Code\ Light:h11
let g:neovide_cursor_trail_size=0

set bg               =dark
let g:gruvbox_italic =1
let g:gruvbox_bold   =1

auto VimEnter * ++nested colorscheme gruvbox

set mouse      =a
set viminfo   +=n/home/jimbo/.config/nvim/viminfo
set history    =1000
set tabstop    =4
set scrolloff  =5
set laststatus =2
set shiftwidth =4
set signcolumn =auto

set number
set nowrap
set showcmd
set nobackup
set expandtab
set incsearch
set smartcase
set splitbelow
set ignorecase
set nohlsearch
set cursorline
set relativenumber

set wildmenu
set wildmode   =list:longest
set wildignore =*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" keybinds

let mapleader = " "

imap jj <esc>                 

nmap \         :NERDTreeToggle<cr>
nmap `         :70vs term://$SHELL<cr>
nmap <leader>g :vs term://lazygit<cr>

nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

imap <C-up>   <esc>:move -2<cr>a
imap <C-down> <esc>:move +1<cr>a

vmap <leader>c :Commentary<cr>
nmap <leader>c :Commentary<cr>

tmap ` <C-\><C-n>:q!<cr>

inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

inoremap <expr><tab>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" autocmds

auto BufNewFile,BufRead *.rasi setf css                                     
auto BufNewFile,BufRead *.rs   nmap <leader>r :10sp term://cargo run<cr>
auto BufNewFile,BufRead *.py   nmap <leader>r :10sp term://python %<cr>

auto BufWritePost *.*.in      exec "!~/.dotfiles/replace.sh %"
auto BufWritePost init.vim.in source %:r 

auto BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal i | endif

" statusline

auto ColorScheme * hi User1        gui=bold guibg=#ebdbb2 guifg=#282828
auto ColorScheme * hi StatusLine   gui=none guibg=#32302f      guifg=#ebdbb2
auto ColorScheme * hi StatusLineNC gui=none guibg=#282828 guifg=#ebdbb2

set statusline =   
set statusline +=%{%StatuslineMode()%}
set statusline +=\ %.40f 
set statusline +=\ [%M]
set statusline +=%<%=
set statusline +=%{strlen(&fenc)?&fenc:'none'}\ %{&ff}\ %l:%v\ 
set statusline +=\ %Y\ 
set statusline +=%1*\ %n\ %0* 

function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#"n"
    hi MyNormal  gui=bold guibg=#ebdbb2 guifg=#282828
    return "%#MyNormal#\ NORMAL\ %0*"
  elseif l:mode==?"v"
    hi MyVisual  gui=bold guibg=#b8bb26  guifg=#282828
    return "%#MyVisual#\ VISUAL\ %0*"
  elseif l:mode==#"i"
    hi MyInsert  gui=bold guibg=#fb4934   guifg=#ebdbb2
    return "%#MyInsert#\ INSERT\ %0*"
  elseif l:mode==#"R"
    hi MyReplace gui=bold guibg=#fe8019 guifg=#ebdbb2
    return "%#MyReplace#\ REPLACE\ %0*"
  elseif l:mode==?"s"
    hi MySelect  gui=bold guibg=#458588   guifg=#ebdbb2
    return "%#MyReplace#\ SELECT\ %0*"
  elseif l:mode==#"t"
    hi MyTerm    gui=bold guibg=#fabd2f  guifg=#ebdbb2
    return "%#MyTerm#\ TERMINAL\ %0*"
  elseif l:mode==#"c"
    hi MyCommand gui=bold guibg=#689d6a   guifg=#ebdbb2
    return "%#MyCommand#\ COMMAND\ %0*"
  elseif l:mode==#"!"
    hi MyShell   gui=bold guibg=#b16286   guifg=#ebdbb2
    return "%#MyShell#\ SHELL\ %0*"
  endif
endfunction

