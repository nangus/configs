set autoindent
set autowrite
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set number
set suffixesadd+=.js

map bn :bn<CR>
map tt :NERDTreeToggle<CR>

syntax enable
set background=dark
colorscheme martin_krischik
colorscheme lettuce

nmap = :Tabularize /=<CR>
vmap = :Tabularize /=<CR>
nmap ; :Tabularize /:<CR>
vmap ; :Tabularize /:<CR>
