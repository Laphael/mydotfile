" 本配置使用vim-plug来管理vim的插件

"--------自动安装vim-plug----------------"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

"--------vim-plug安装结束--------------"


"--------基本设置-----------------------------"

set vb t_vb=                         " 取消vim的响铃
set t_Co=256                         " 开启vim终端下256颜色显示
set nocompatible                     " 取消vi兼容
filetype plugin indent on            " 打开文件类型检测并在runtimepath中加载插件配置与缩进
if !exists("g:syntax_on") | syntax enable | endif   " 启用代码语法高亮

set number                           " 显示行号
set relativenumber                   " 显示相对行号（相对当前光标所在行）
set ruler                            " 右下角显示当前光标位置行列号
set showmatch                        " 自动高亮对应另一半括号
set hlsearch                         " 搜索高亮
set incsearch                        " 每输入一个字符就自动搜索
set laststatus=1                     " 打开2个及以上buffer时显示底边状态栏
auto InsertEnter * set cursorline    " 进入Insert模式时高亮光标所在行
auto InsertLeave * set nocursorline  " 退出Insert模式时取消高亮光标所在行

set autochdir                        " 自动切换工作目录
set scrolloff=5                      " 光标距窗口上下保留5行
set mouse=nv                         " 允许鼠标在normal模式和visual模式下工作
set backspace=indent,eol,start       " 使用<Backspace>删除
let &termencoding=&encoding          " 使终端使用当前编辑文本的编码类型，解决编码造成的显示乱码问题
set fileencodings=utf-8,gbk,gb2312,gb18030      " 设置写入文件时所支持的文件编码类型

set expandtab                       " 扩展制表符为空格
set tabstop=4   	                " 制表符占空格数
set softtabstop=4	                " 将连续数量的空格视为一个制表符
set shiftwidth=4	                " 自动缩进所使用的空格数
set textwidth=79	                " 编辑器每行字符数
set wrap                            " 设置自动折行
set linebreak                       " 防止单词内部折行
set wrapmargin=5                    " 指定折行处与右边缘空格数
set autoindent  	                " 打开自动缩进
set smartindent                     "  智能缩进，每行都和前一行的缩进量相同，还能识别花括号，遇到 { 则取消缩进
set wildmenu    	                " vim命令自动补全
"set paste                           " 在粘贴时不会自动添加"来注释

"--------基本设置结束--------------------------"


"--------安装vim插件--------------"

call plug#begin()
" 插件默认安装目录为 '~/.vim/plugged'

" nerdtree侧边栏工具
Plug 'scrooloose/nerdtree'
"---------------------------------------------------------------------
" vim-airline插件，类似于powerline
Plug 'vim-airline/vim-airline'
"---------------------------------------------------------------------
" vim-gutentags插件，用于自动生成tags
Plug 'ludovicchabant/vim-gutentags'

" 使用此插件，必须首先安装Universal Ctags

" 设置gutentags结束搜索工程目录的标志
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

" 生成的tags数据文件的名称 
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测目录 ~/.cache/tags 是否存在，不存在就新建 
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 排除不想生成tags的文件
let g:gutentags_ctags_exclude = [
          \ '.vimrc',
          \                                 ]


" 使用 CTRL-W ] 用新窗口打开并查看光标下符号的定义，
" 使用 CTRL-W } 用 preview 窗口预览光标下符号的定义。
"---------------------------------------------------------------------
" AsyncRun异步编译运行插件
Plug 'skywind3000/asyncrun.vim'

" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6

" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

" 单文件的编译和运行,按F9编译,按F5运行
" 定义F9为编译当前文件
nnoremap <silent> <F9> :AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
" 定义F5为运行编译的结果,其中"-cwd=$(VIM_FILEDIR)"的意思是在当前文件所在的目录下运行,后面的运行路径使用了全路径,从而避免了 linux 下面当前路径加 “./” 而 windows 不需要的跨平台问题。
" 参数 `-raw` 表示输出不用匹配错误检测模板 (errorformat) ，直接原始内容输出到 quickfix 窗口。这样你可以一边编辑一边 F9 编译，出错了可以在 quickfix 窗口中按回车直接跳转到错误的位置，编译正确就接着执行。
nnoremap <silent> <F5> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
"---------------------------------------------------------------------
" ALE动态语法检查插件
Plug 'dense-analysis/ale'

" 定义编程语言使用的linter
let g:ale_linters = {
\   'c': ['gcc'],
\   'c++': ['cppcheck'],
\   'python': ['flake8'],
\
\}
" 除了上面定义的"ale_linters"之外，不开启ale
let g:ale_linters_explicit = 1

let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500

" 为了避免YoucompleteMe的实例对话框频繁刷新，进行下面两行关于normal和insert模式的定义
let g:ale_lint_on_text_changed = 'normal'           " normal模式下如果文字改变了,就运行linter
let g:ale_lint_on_insert_leave = 1					" 离开insert模式时，运行Linter

" 在vim-airline上显示ale的状态信息
let g:airline#extensions#ale#enabled = 1

" 设置ale的错误信息的输出格式
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

" 使用quickfix windows代替loclist，暂时感觉没必要
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
"let g:ale_open_list = 1
"let g:ale_keep_list_window_open = 0

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta
"---------------------------------------------------------------------
" vim-signify用来在侧边栏显示当前文件和仓库里的文件的对比状态
" 支持 git/svn/mercurial/cvs 等十多种主流版本管理系统
Plug 'mhinz/vim-signify'

" 默认的更新时间是4000ms,对于异同步更新来说不太合适,这里改为100ms
set updatetime=100
"---------------------------------------------------------------------
" YouCompleteMe自动补全插件
Plug 'valloric/youcompleteme'

" 不显示ycm的诊断信息,用ale来提供
let g:ycm_show_diagnostics_ui = 0

let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1

" 定义触发补全的快捷键是crtl+z
let g:ycm_key_invoke_completion = '<c-z>'

" 屏蔽ycm自动弹出的函数原型预览窗口
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0

noremap <c-z> <NOP>

" 弹出窗口的配色修改,从默认的粉红改成灰色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

" 只要输入2个字符,ycm就会开启补全
let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }

" 设置ycm的白名单，不在名单中的文件类型ycm不会去分析
let g:ycm_filetype_whitelist = { 
			\ "c":1,
			\ "cpp":1, 
			\ "py":1,
			\ "sh":1,
			\ "zsh":1,
			\ }

" 禁止ycm对下面3种类型的文件自动补全(本来也不支持）。
" 这3种文件的补全功能由vim-auto-popmenu来提供
let g:ycm_filetype_blacklist = {'text':1, 'markdown':1, 'php':1}
"---------------------------------------------------------------------
" leaderF插件用来查看函数列表
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<m-n>'
noremap <c-n> :LeaderfMru<cr>
noremap <m-p> :LeaderfFunction!<cr>
noremap <m-n> :LeaderfBuffer<cr>
noremap <m-m> :LeaderfTag<cr>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
"---------------------------------------------------------------------
" auto-pairs用来自动匹配括号
Plug 'jiangmiao/auto-pairs'
"---------------------------------------------------------------------
"echodoc用来显示函数的参数提示
Plug 'Shougo/echodoc.vim'

" 关闭底部的提示
set noshowmode
"---------------------------------------------------------------------
" 修改vim的启动页
Plug 'mhinz/vim-startify'
"---------------------------------------------------------------------
" janah主题
Plug 'mhinz/vim-janah'
"---------------------------------------------------------------------


"---------------------------------------------------------------------
call plug#end()

"--------vim插件安装结束-------------"


"-------- janah颜色主题设置-----------------"
"必须写在 call plug#end()之后才能起作用

" 在使用xshell,securecrt等终端模拟器时,janah默认不会设置vim的背景色，这里添加上
autocmd ColorScheme janah highlight Normal ctermbg=235

" 设置行号栏的背景色,与上面的vim背景色相同
autocmd ColorScheme janah highlight LineNr ctermbg=235
colorscheme janah
"--------janah颜色主题设置结束--------------"
