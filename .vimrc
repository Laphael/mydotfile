" 本配置使用vim-plug来管理vim的插件

"--------自动安装vim-plug----------------"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

"--------vim-plug安装结束--------------"


"--------基本设置-----------------------------"
" 使用分号 ; 作为leader键
let mapleader = ";"

"让vim记住上次编辑和浏览的位置
if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set termguicolors                    " 开启turecolor,无需再设置set t_Co=256
set vb t_vb=                         " 取消vim的响铃
set nocompatible                     " 取消vi兼容
filetype plugin indent on            " 打开文件类型检测并在runtimepath中加载插件配置与缩进

"语法高亮开启
"syntax enable 其实是执行了 :source $VIMRUNTIME/syntax/syntax.vim 这个命令, 如果没有设置 VIM 环境变量，Vim 会试图用其它方法找到该路径。syntax enable命令会保持绝大部分你当前的色彩设置。这样，不管在使用此命令的前后，你都可以用  :highlight  命令设置你喜欢的颜色
"  synatax on 是用Vim的缺省值覆盖你自己的配置
if !exists("g:syntax_on") | syntax enable | endif   " 启用代码语法高亮

set number                           " 显示行号
set relativenumber                   " 显示相对行号（相对当前光标所在行）
set ruler                            " 右下角显示当前光标位置行列号
set showmatch                        " 自动高亮对应另一半括号
set hlsearch                         " 搜索高亮
set incsearch                        " 每输入一个字符就自动搜索
set ignorecase                       " 搜索时忽略大小写
set smartcase                        " 打开ignorecase后，搜索只有一个大写字母的词会大小写敏感，其它不敏感:搜索Test时将不匹配test；搜索test时将匹配Test
set cursorline                       " 高亮显示当前行
set autochdir                        " 自动切换工作目录
set scrolloff=3                      " 光标距窗口上下保留3行
set mouse=nv                         " 允许鼠标在normal模式和visual模式下工作
set backspace=indent,eol,start       " 使用<Backspace>删除
set encoding=utf-8                   " 让Vim内部所有的内容的编码全部使用utf-8
let &termencoding=&encoding          " 使终端使用当前编辑文本的编码类型，解决编码造成的显示乱码问题
set fileencodings=utf-8,gb2312,gbk,gb18030      " 设置vim自动侦测文件编码类型的顺序

set undofile                        " 保留撤销历史记录。可以在文件关闭后，操作记录保留在一个文件里面继续存在
set expandtab                       " 自动将 Tab 转为空格
set tabstop=4   	                " 制表符占空格数
set softtabstop=4	                " 将连续数量的空格视为一个制表符
set shiftwidth=4	                " 在文本上按下>>（增加缩进）、<<（减少缩进）或者==（取消缩进）时每一级的字符数为4。
set textwidth=80	                " 设置行宽为80
set wrap                            " 设置自动折行
set linebreak                       " 防止单词内部折行
set wrapmargin=2                    " 指定折行处与右边缘的空格数
set autoindent  	                " 按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致。
set smartindent                     "  智能缩进，每行都和前一行的缩进量相同，还能识别花括号，遇到 { 则取消缩进
set wildmenu    	                " 命令模式下vim命令自动补全

" 普通模式下按 p 粘帖的内容就是系统剪切板里的内容了
set clipboard=unnamedplus
"--------基本设置结束--------------------------"

"--------安装vim插件--------------"

call plug#begin()
" 插件默认安装目录为 '~/.vim/plugged'
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"---------------------------------------------------------------------
" vim-airline插件，类似于powerline
Plug 'vim-airline/vim-airline'
"---------------------------------------------------------------------
" 修改vim的启动页
Plug 'mhinz/vim-startify'

"起始页显示的列表长度
let g:startify_files_number = 10
""自动加载session
let g:startify_session_autoload = 1
"过滤列表，支持正则表达式
let g:startify_skiplist = [
       \ '^/tmp',
              \ ]

"---------------------------------------------------------------------
" gruvbox主题
Plug 'morhetz/gruvbox'
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
" leaderF是搜索工具，用来查找本地文件、buffers、MRUS、gtags等
 Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" popup mode
 let g:Lf_WindowPosition = 'popup'
 let g:Lf_PreviewInPopup = 1
 let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "Sarasa Mono SC Nerd" }
 let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>


"---------------------------------------------------------------------
call plug#end()

"--------vim插件安装结束-------------"

"-------- gruvbox颜色主题设置-----------------"
let g:gruvbox_italic=1                      " 支持斜体
let g:gruvbox_contrast_dark='hard'
set background=dark
colorscheme gruvbox
"--------gruvbox颜色主题设置结束--------------"

"--------coc.mvim配置开始-------------------"
" 使用coc.nvim自己的插件管理器来安装coc相关的插件
let g:coc_global_extensions = ['coc-explorer','coc-vimlsp', 'coc-clangd','coc-json', 'coc-python', 'coc-snippets', 'coc-marketplace']

" 使用<leader>e来打开coc-explorer
nnoremap <leader>e :CocCommand explorer<CR>

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-o> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-o> coc#refresh()
else
  inoremap <silent><expr> <c-o> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" 使用Leader+h可能会更好,一会修改
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" 光标放在一个词上，可以高亮其它相同的词，安装coc-highlight才有效果
" 同类插件是vim-illuminate
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" 右键选中一块代码,会提供一些功能选项,
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
"--------coc.nvim配置结束------------------------------"



