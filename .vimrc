"本配置文件使用vim-plug来管理vim的插件

"--------自动安装vim-plug----------------"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

"--------vim-plug安装结束--------------"


"--------安装vim插件--------------"

call plug#begin()
" 插件默认安装目录为 '~/.vim/plugged'


" nerdtree侧边栏工具
Plug 'scrooloose/nerdtree'

" vim-airline插件，类似于powerline
Plug 'vim-airline/vim-airline'

" vim-gutentags插件，用于自动生成tags
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

"--------vim插件安装结束-------------"


"--------基本设置-----------------------------"

set vb t_vb=                         " 取消vim的响铃
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
set wildmenu    	                " vim命令自动补全
set paste                           " 在粘贴时不会自动添加"来注释

"--------基本设置结束--------------------------"
"
"
"--------vim-gutentags配置---------------------"
" 使用此插件，必须首先安装Universal Ctags

" 设置gutentags结束搜索工程目录的标志,
" 碰到下面这些文件或者目录名就停止向上一级目录递归搜索
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

" 使用 CTRL-W ] 用新窗口打开并查看光标下符号的定义，
" 使用 CTRL-W } 用 preview 窗口预览光标下符号的定义。

"--------vim-gutentags配置结束--------------------"

