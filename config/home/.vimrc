set nobackup
set nowb
set noswapfile
set noerrorbells

set encoding=UTF-8
set mouse=a

if !has('nvim')
    set ttymouse=xterm2
endif

set so=999
set clipboard=unnamedplus
set wildmenu

if has('mac')
    set clipboard=unnamed
endif

set autoindent
set smartindent

" Appearance "

syntax enable

set number
set relativenumber
set linespace=12

set title
set titlestring=%F\ -\ vim
set guicursor=
set noshowmode
set laststatus=2

set background=dark

" File behaviour "

set expandtab
set smarttab
set linebreak
set breakindent
set nostartofline

set shiftwidth=4
set tabstop=4

" Search "

set smartcase
set hlsearch
set incsearch

" Panes "

set splitbelow
set splitright

set timeoutlen=1000 ttimeoutlen=0


" Filetype associations "

autocmd BufRead,BufNewFile *.fish set ft=fish
autocmd BufRead,BufNewFile *.MD set filetype=markdown
autocmd BufRead,BufNewFile *.qrc set filetype=xml
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * lcd %:p:h
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * wincmd h
autocmd FileType gitcommit setlocal spell
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

" Bindings "

set backspace=indent,eol,start

map <M-q> :q <CR>
map <M-a> :w <CR>
map ' :Ag<CR>
map <F6> :setlocal spell!<CR>
map <silent> <C-o> :NERDTreeToggle<CR>
map <silent> <C-d> :term<CR>
map <silent> <M-e> :tab new<CR>
map <silent> <M-r> :Run<CR>
map <silent> <M-d> :w <bar> :Run<CR>
map <Leader> <Plug>(easymotion-prefix)
map <silent> <M-k> :wincmd k<CR>
map <silent> <M-j> :wincmd j<CR>
map <silent> <M-h> :wincmd h<CR>
map <silent> <M-l> :wincmd l<CR>
map <silent> <F9> :!%:p <CR>
map <M-1> 1gt
map <M-2> 2gt
map <M-3> 3gt
map <M-4> 4gt
map <M-5> 5gt
map <M-6> 6gt
map <M-7> 7gt
map <M-8> 8gt
map <M-9> 9gt
map <M-0> 0gt
map <M-o> :bnext <CR>
map <M-i> :bprevious <CR>
map <M-v> :vs <CR>
map <M-t> :tabe <CR>
map <M-s> :split <CR>

let g:gruvbox_vert_split = 'bg1'
let g:gruvbox_sign_column = 'bg0'
let g:termwinsize=10
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 25
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#keymap_ignored_filetypes = ['vimfiler', 'nerdtree']
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

hi clear SpellBad
hi SpellBad cterm=underline ctermfg=darkred
hi EndOfBuffer ctermfg=black

hi GitGutterAdd ctermfg=green ctermbg=NONE
hi GitGutterChange ctermfg=yellow ctermbg=NONE
hi GitGutterDelete ctermfg=darkred ctermbg=NONE
hi GitGutterChangeDelete ctermfg=yellow ctermbg=NONE

let g:vim_run_command_map = {
  \'javascript': 'npm run',
  \'php': 'php',
  \'python': 'python',
  \}

exec "map \ed <M-d>"
exec "map \ea <M-a>"
exec "map \eq <M-q>"
exec "map \er <M-r>"
exec "map \ee <M-e>"
exec "map \el <M-l>"
exec "map \ek <M-k>"
exec "map \ej <M-j>"
exec "map \eh <M-h>"
exec "map \er <M-r>"
exec "map \e9 <M-9>"
exec "map \e8 <M-8>"
exec "map \e7 <M-7>"
exec "map \e6 <M-6>"
exec "map \e5 <M-5>"
exec "map \e4 <M-4>"
exec "map \e3 <M-3>"
exec "map \e2 <M-2>"
exec "map \e1 <M-1>"
exec "map \e0 <M-0>"
exec "map \ei <M-i>"
exec "map \eo <M-o>"
exec "map \es <M-s>"
exec "map \ev <M-v>"
exec "map \et <M-t>"

function! s:str2list(expr) abort
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

function! s:error(msg) abort
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[vim-etc] ' . l:mes | echohl None
	endfor
endfunction

function! s:load_yaml(filename) abort
	let l:cmd = "python -c 'import sys,yaml,json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'"
	try
		let l:raw = readfile(a:filename))
		return json_decode(system(l:cmd, l:raw))
	catch /.*/
		call s:error([
			\ string(v:exception),
			\ 'Error loading ' . a:filename,
			\ 'Caught: ' . string(v:exception),
			\ 'Please run: pip install --user PyYAML',
			\ ])
	endtry
endfunction

function! s:dein_load_yaml(filename) abort
	"echo a:plug_file
    "let g:denite_plugins = s:load_yaml(a:plug_file)

	python3 << endpython
import vim, yaml
with open(vim.eval('a:filename'), 'r') as f:
	vim.vars['denite_plugins'] = yaml.safe_load(f.read())
endpython
    for plugin in g:denite_plugins
		call dein#add(plugin['repo'], extend(plugin, {}, 'keep'))
	endfor
	unlet g:denite_plugins
endfunction

let s:path = glob('~/.vim/dein')
if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = 1
		let g:dein#install_max_processes = 16
		let g:dein#install_progress_type = 'echo'
		let g:dein#enable_notification = 1
		let g:dein#install_log_filename = glob('~/.vim/dein.log')

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = s:path . '/repos/github.com/Shougo/dein.vim'
			" Clone dein if first-time setup
			if ! isdirectory(s:dein_dir)
				execute '!curl -s https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | bash /dev/stdin ~/.vim/dein/'
				if v:shell_error
					call s:error('dein installation has failed! is git installed?')
					finish
				endif
			endif
			"set runtimepath+=a:dein_dir
		endif
	endif

set runtimepath+=/home/kensai/.vim/dein/repos/github.com/Shougo/dein.vim


" Initialize dein.vim (package manager)
let s:plugins_path = glob('~/.vim/plugins.yml')
if dein#load_state(s:path)
	call dein#begin(s:path, [expand('<sfile>'), s:plugins_path])
	call s:dein_load_yaml(s:plugins_path)
	call dein#end()
	colorscheme onedark
	if dein#check_install()
		if ! has('nvim')
			set nomore
		endif
		call dein#install()
	endif
endif

hi Normal ctermbg=NONE
hi CursorLineNr ctermfg=white
hi SignColumn ctermbg=NONE

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let g:ale_completion_enabled = 1

" Files + devicons
function! Fzf_files_with_dev_icons(command)
  let l:fzf_files_options = '--preview "bat --color always --style numbers {2..} | head -'.&lines.'"'
   function! s:edit_devicon_prepended_file(item)
    let l:file_path = a:item[4:-1]
    execute 'silent e' l:file_path
  endfunction
   call fzf#run({
        \ 'source': a:command.' | devicon-lookup',
        \ 'sink':   function('s:edit_devicon_prepended_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction
 function! Fzf_git_diff_files_with_dev_icons()
  let l:fzf_files_options = '--ansi --preview "sh -c \"(git diff --color=always -- {3..} | sed 1,4d; bat --color always --style numbers {3..}) | head -'.&lines.'\""'
   function! s:edit_devicon_prepended_file_diff(item)
    echom a:item
    let l:file_path = a:item[7:-1]
    echom l:file_path
    let l:first_diff_line_number = system("git diff -U0 ".l:file_path." | rg '^@@.*\+' -o | rg '[0-9]+' -o | head -1")
     execute 'silent e' l:file_path
    execute l:first_diff_line_number
  endfunction
   call fzf#run({
        \ 'source': 'git -c color.status=always status --short --untracked-files=all | devicon-lookup',
        \ 'sink':   function('s:edit_devicon_prepended_file_diff'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction

 " Open fzf Files
map <C-p> :call Fzf_files_with_dev_icons('ag -l -g ""')<CR> " :Files
map <C-l> :call Fzf_git_diff_files_with_dev_icons()<CR> " :GFiles?

let g:rainbow_active = 1

let g:ale_sign_error = '✖'
let g:ale_sign_info = 'ⓘ'
let g:ale_sign_warning = '⚠'
let g:ale_cpp_clang_options = '-I ../include -I ../vendor/include -std=c++14 -stdlib=libc++ -fPIC -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../include/c++/9.2.0 -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../include/c++/9.2.0/x86_64-pc-linux-gnu -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/../../../../include/c++/9.2.0/backward -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/include -isystem /usr/local/include -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/9.2.0/include-fixed -isystem /usr/include'

let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_modules=['ctags', 'gtags_cscope']

let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

