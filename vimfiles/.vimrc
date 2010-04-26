let mapleader=","
"kkkkkk" ����
" :echo $VIMRUNTIME/../vimfiles/plugin/
":bdelete 3     "��һ�����������б���ȥ��
":bwipe         "��һ�����������б��г���ȥ��

"���İ���
"if version > 603
    "set helplang=cn
"end

if v:progname =~? "evie"
	finish
endif

if has("win32")
    set fileencoding=chinese
else
    set fileencoding=utf-8
endif

if has("gui_running")
    "�趨 windows �� gvim ����ʱ���
    "autocmd GUIEnter * simalt ~
    set lines=48
    set columns=84
    winpos  10  0
    if exists("&cursorline")
        set cursorline  "Highlight current
    endif
else
    set lines=30
    set columns=86
    winpos  80  10
endif

" Platform
function! MySys()
    if has("win32")
	return "windows"
    else 
	return "linux"
endfunction

" Switch to buffer according to file name
function! SwitchToBuf(filename)
    let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")   "For linux
    "��filename����fullfn, �����κ��滻
    "let fullfn = substitute(a:filename, "NotFounded", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(fullfn)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(fullfn)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . fullfn
    endif
endfunction

"��sdcv��vim������Ļȡ��
"echo "$Definition" |
"sed -n '1,/^[A-Z]/p' |
"#  ������ĵ�һ�д�ӡ����һ���ֵĵ�һ��.
"sed '$d' | sed '$d'

function! Mydict()
	"let expl0=system('sdcv -n ' .
	let expl=system('sdcv.sh ' .
	\ expand("<cword>"))
	windo if
	\ expand("%:p")=="/tmp/diCtTmp" |
	\ wq!|endif
	botright vertical 20split /tmp/diCtTmp
	"25vsp diCtTmp
	"botright aboveleft 20split /tmp/diCtTmp
	setlocal buftype= bufhidden=hide noswapfile
	"setlocal buftype=nofile bufhidden=hide noswapfile
	1s/^/\=expl/
	1
endfunction

function! Firefox_jsp()
	let ttmp=expand("<cWORD>")
	let jsp_path="http://10.3.10.19:8080/sy/"
	" jsp_fullpath="http://10.3.10.19:8080/sy/$ttmp"
	let jsp_fullpath= jsp_path . ttmp			
	let t3=system('firefox -height 50 -width 40 ' . jsp_fullpath)
endfunction

function! Testfun()
	let ttmp=expand("<cWORD>")
	let jsp_path="http://10.3.10.19:8080/sy/"
	echo ttmp
	let t2= jsp_path . ttmp
	echo t2
	let t3=system('firefox ' . t2)
	echo t3
endfunction

"Fast edit vimrc
if MySys() == 'linux'
    map <silent> <leader>wvim :call SwitchToBuf("/media/C/Vim/Vim/_vimrc")<cr>
    map <silent> <leader>vio :call SwitchToBuf("/media/F/notes/blog/vim/13vim_skill.txt")<cr>
    map <silent> <leader>vib :call SwitchToBuf("/media/F/notes/blog/book/01.txt")<cr>
    map <silent> <leader>vik :call SwitchToBuf("/media/F/notes/blog/vim/script/vim_script_settings_of_me.txt")<cr>
    map <silent> <leader>vie :call SwitchToBuf("/media/F/notes/blog/english/e-new-words.txt")<cr>
    map <silent> <leader>vif :call SwitchToBuf("~/.vimperatorrc")<cr>
    map <silent> <leader>vig :call SwitchToBuf("/media/F/notes/blog/vim/regular-expression/regular_expressions_test.txt")<cr>
    map <silent> <leader>viw :call SwitchToBuf("/media/F/notes/blog/z_other/01OneThousandWrods.txt")<cr>
    map <silent> <leader>vll :call SwitchToBuf("~/.vim/log.txt")<cr>
    "Fast reloading of the .vimrc
    map <silent> <leader>vis :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>vim :call SwitchToBuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    let path="C:\Vim\Vim"
    "Fast reloading of the _vimrc
    map <silent> <leader>vis :source ~\_vimrc<cr>
    "Fast editing of _vimrc
    map <silent> <leader>vim :call SwitchToBuf("C:/Vim/Vim/_vimrc")<cr>
    map <silent> <leader>vio :call SwitchToBuf("F:/notes/blog/vim/13vim_skill.txt")<cr>
    map <silent> <leader>vib :call SwitchToBuf("F:/notes/blog/book/01.txt")<cr>
    map <silent> <leader>vik :call SwitchToBuf("F:/notes/blog/vim/script/vim_script_settings_of_me.txt")<cr>
    map <silent> <leader>vie :call SwitchToBuf("F:/notes/blog/english/e-new-words.txt")<cr>
    map <silent> <leader>vif :call SwitchToBuf("C:/Vim/Vim/_vimperatorrc")<cr>
    map <silent> <leader>vig :call SwitchToBuf("F:/notes/blog/vim/regular-expression/regular_expressions_test.txt")<cr>
    map <silent> <leader>viw :call SwitchToBuf("F:/notes/blog/z_other/01OneThousandWrods.txt")<cr>
    "When _vimrc is edited, reload it
    autocmd! bufwritepost _vimrc source ~\_vimrc
endif

"#############################################################################
" settings sets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType c,cpp set nomodeline " @@@@@
au FileType text, txt, TXT set tw=78 fo+=Mm "ѡ�У�Ȼ��gq�Ϳ���
autocmd BufReadPost *       " @@@@@
\ if line("��\"") > 0 && line("��\"") <= line("$") |
\ exe "normal g`\"" |
\ endif

filetype on
filetype plugin on "�Զ�ʶ���ļ����ͣ��Զ�ƥ���Ӧ���ļ�����Plugin.vim�ļ�
filetype plugin indent  on "�Զ�ʶ���ļ����ͣ��Զ�ƥ���Ӧ���ļ�����Plugin.vim�ļ�
set statusline=%f%m%r,%Y,%{&fileformat}\ \ \ ASCII=\%b,HEX=\%B\ \ \ %l,%c%V\
\ %p%%\ \ \ [%L\ lines]         "������״̬����ʾ����Ϣ

set ai
set ambiwidth=double            "����Ϊȫ��
set autochdir                   "�Զ��л�Ŀ¼
set autoindent                  "�����Զ�����
set backspace=indent,eol,start  "�ڲ���״̬ʹ�ÿ������˸����Delete��ɾ���س���
set backup
set backupcopy=yes              "���ñ���ʱ����ΪΪ����
set bsdir=buffer                "�趨�ļ������Ŀ¼Ϊ��ǰĿ¼
set cindent                     "����Ϊ C ���Է�������ģʽ
set cmdheight=1                 "�趨�����е�����Ϊ 1
set fileencodings=utf-8,chinese "@@@@@
"set foldmethod=indent			"�����������۵�
set formatoptions+=tcqroMm      "ʹ��ע�ͻ���ʱ�Զ�����ǰ���Ŀո���Ǻ�
set guioptions-=L
set guioptions-=m               "ȥ���˵���
set guioptions-=r               "ȥ���ұ߹�����
set guioptions-=T               "ȥ��������
set history=400                 "����ð����������������������ʷ�б�ĳ���
set hlsearch                    "���������������ʾ
set incsearch                   "������������ʱ����ʾ�������
set laststatus=1                "2Ϊ��ʾ״̬�� (Ĭ��ֵΪ 1, �޷���ʾ״̬��)
set linespace=2                 "�м��
set matchtime=7
set mouse=a
set nobackup                    "�����ļ�ʱ������
set nocompatible                "������vi
set noeb
set nolinebreak                 "�ڵ����м����
set novb
set nowarn
set number                      "��ʾ�к�
set ruler                       "show the cursor position all the time
set scrolloff=2                 "�趨����봰�����±߽�2��ʱ�����Զ�����
set showcmd                     "��״̬����ʾĿǰ��ִ�е�ָ�� @@@@@
set showmatch
set smartindent
set shiftwidth=4                "�趨 << �� >> �����ƶ�ʱ�Ŀ��
set softtabstop=4               "ʹ�ð��˸��ʱ����һ��ɾ�� 4 ���ո�
set tabstop=8                   "tab���Ϊ�ĸ��ַ�
"set textwidth=78 fo+=Mm         "�Ե�ǰ�ļ������Զ�����
set title                       "�ڱ�������ʾ�ļ��Ƿ���Ի��Ѿ����޸�
set whichwrap=b,s,<,>,[,]       "����ǰͷ�����ƶ�
syntax enable
syntax on                       "�����﷨����

"colorscheme  candycode
"colorscheme  darkblue
colorscheme default
"colorscheme peachpuff
"colorscheme  relaxedgreen
"colors settings
"hi Normal guibg=#cfe8cc ctermfg=gray ctermbg=black
"set background=dark
set background=light
hi Normal guibg=#cfe8cc

"lcd e:/vimroot                 "����GVIMĬ��Ŀ¼
"set comments=://   "C/C++ע��
"set comments=s1:/*,mb:*,ex0:/  "�����Զ�Cʽ��ע�͹��� <2005/07/16>
"set confirm                    "��ȷ�϶Ի��򵯳�������Ϣ
"set display=lastline           "���в�����ȫ��ʾʱ��ʾ��ǰ��Ļ����ʾ�Ĳ���
"set encoding=utf-8             "�����ַ����� @@@@@
"set expandtab                  "ʹ��space����tab.
"set fileformats=unix,dos       "���ñ����ļ���ʽ
"set filetype=php               "����Ĭ���ļ�����
"set guifont=SimSun\ 10         "��������GUIͼ���û�����������б�
"set hidden                     "��������δ������޸�ʱ�л�������
"set ignorecase smartcase       "�������Դ�Сд, ������һ�����ϴ�д��ĸʱ������
"set list                       "��ʾ���з�$
"set noignorecase               "�����ִ�Сд
"set nowrap                     "���������ҹ���
"set vb t_vb=                   "�ر�����
"set vb                         "����ʱ����
"set viminfo @@@@@
"set viminfo='20,<50,s10,h
"########################## end of settings ##################################
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"#############################################################################
" use iabbrev
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"������������Vim������ÿ�μ���"ad"�Ϳո���Զ���չΪ"advertisement":
iabbrev ad advertisement
iabbrev crv createvar
iabbrev LDD $(LDDIR)
iabbrev ldd $(LDDIR)
iabbrev LDL $(LDLIBS)
iabbrev ldl $(LDLIBS)
iabbrev CO $(COMPILE.c)
iabbrev co $(COMPILE.c)
iabbrev LI $(LINK.c)
iabbrev li $(LINK.c)
iabbrev inc include
iabbrev PR PROGS =
iabbrev pr PROGS =
iabbrev pro $(PROGS)
"iabbrev ob objects =
"iabbrev obj $(objects)
iabbrev //b /*************************************************************************
iabbrev //e <space>*************************************************************************/
iabbrev "b """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iabbrev "e """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iabbrev /u /usr/local/share/vim/vim72/
iabbrev plu $HOME/.vim/plugin
iabbrev doc $HOME/.vim/doc
iabbrev vimm C:\Program Files\Vim\vim72
iabbrev fil C:\Program Files\Vim\vimfiles
"######################## end of iabbrev #####################################



"#############################################################################
" use abbreviate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
abbreviate teh the
abbreviate mian main
"######################## end of abbreviate ##################################



"#############################################################################
" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"=============================================================================
" ctags settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nmap g] g]:pwd<cr>
nmap <C-T> <C-T>:pwd<cr>
set complete=.,w,b,u,t,i
"set tags=/home/liaocaiyuan/book/unpv22e/tags
set tags+=tags "���д��+=
set tags+=./tags,./../tags,./../../tags,./../../../tags,./**/tags,tags
if MySys() == 'linux'
    au FileType c     set tags+=/home/scr/lang/cpp/minix_svn/tags
    "au FileType c,cpp set tags+=/home/scr/lang/0ctope/libc/libc/tags
    "au FileType c,cpp set tags+=/home/scr/lang/0ctope/cpp/cpp_src/tags
    "au FileType c,cpp set tags+=/home/scr/lang/0ctope/win32/winapi/tags
    "au FileType   cpp set tags+=/home/scr/lang/0ctope/win32/mfc/tags
    au FileType  java set tags+=/home/scr/lang/0ctope/java_api/src/tags
elseif MySys() == 'windows'
    au FileType c,cpp set tags+=E:\lang\cpp\cpp\cpp_src\tags "cpp_src.tar.bz2
    au FileType c,cpp set tags+=E:\lang\win32\mfc\tags
    au FileType c,cpp set tags+=E:\lang\win32\winapi\tags
    au FileType c,cpp set tags+=C:\project\orge\OgreSDK\orge_main_src\tags
    au FileType c,cpp set tags+=E:\liaocaiyuan\destop\ogre\ogre2\include\orz\tags
    au FileType c,cpp set tags+=C:\project\orge\OgreSDK\include\tags
    au FileType  java set tags+=E:\lang\java\java_api\src\tags
endif

"=============================================================================
"vimgdb settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimgdb_debug_file = ""
run macros/gdb_mappings.vim
"map <silent><leader>gdb :run macros/gdb_mappings.vim<cr>
"run C:\\Program Files\\Vim\\vim72\\macros\\gdb_mappings.vim
noremap <silent> <leader>dva 15<C-W>+
iabbrev fo follow-fork-mode
iabbrev pa parent
iabbrev ch child
"set follow-fork-mode  parent/child   "��������ٵĽ���

"=============================================================================
"cscope settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set cscopequickfix=s-,c-,d-,i-,t-,e-
" cscope ���ҵ�������ü� C:\Program Files\Vim\vimfiles\plugin\cscope_map.vim
" nmap <C-\>s      nmap <C-@>s      nmap <C-@><C-@>s
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    " s: ����C���Է��ţ������Һ��������ꡢö��ֵ�ȳ��ֵĵط�
    " g: ���Һ������ꡢö�ٵȶ����λ�ã�����ctags���ṩ�Ĺ���
    " c: ���ҵ��ñ������ĺ���
    " d: ���ұ��������õĺ���
    " t: ����ָ�����ַ���
    " e: ����egrepģʽ���൱��egrep���ܣ��������ٶȿ����
    " f: ���Ҳ����ļ�������vim��find����
    " i: ���Ұ������ļ����ļ�
if MySys() == 'linux'
    "cs a /home/scr/lang/0ctope/win32/mfc/cscope.out
    "cs a /home/scr/lang/0ctope/win32/winapi/cscope.out
    "cs a /home/scr/lang/0ctope/libc/libc/cscope.out
    "cs a /home/scr/lang/0ctope/java_api/src/cscope.out
elseif MySys() == 'windows'
    "cs a E:\lang\win32\mfc\cscope.out
    "cs a E:\lang\win32\winapi\cscope.out
    "cs a E:\lang\java\java_api\src\cscope.out
endif
" ��ʾ��ǰ�����ӡ�
"map <silent> <leader>csh :cs show<cr>
" ���³�ʼ���������ӡ�
map <silent> <leader>cre :cs reset<cr>

"=============================================================================
"TagList settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! TlistToggle_close_diCtTmp(filename, flag)
	let bufwinnr = bufwinnr(a:filename)
	if bufwinnr != -1
		"�ѹ�꽹���Ƶ���Ϊbufwinnr�Ĵ���
		exec bufwinnr . "wincmd w"
		close
	endif
	if a:flag == 0
		TlistToggle
	elseif a:flag == 1
		call Mydict()
	endif
endfunction "tll
map <silent> <leader>tl :call TlistToggle_close_diCtTmp("diCtTmp", 0)<cr>
map <silent> <leader>tf  :call TlistToggle_close_diCtTmp("__Tag_List__", 1)<cr>j<C-W>h
"map <silent> <leader>tl :TlistToggle<CR>

let Tlist_Show_One_File=4
let Tlist_OnlyWindow=0
let Tlist_Use_Right_Window=1
let Tlist_Sort_Type='name'
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_Menu=0 "�����Ϊ0
let Tlist_Max_Submenu_Items=10
let Tlist_Max_Tag_length=20
let Tlist_Use_SingleClick=0
let Tlist_Auto_Open=0
let Tlist_Close_On_Select=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Process_File_Always=1
let Tlist_WinHeight=10
let Tlist_WinWidth=28
let Tlist_Use_Horiz_Window=0
let Tlist_Inc_Winwidth=0  "�����������vim������gvim, �����������Ϊ0.
let TlistShowPrototype = 50

"=============================================================================
"BufExploer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExporerDefaultHelp=0       "Do not show default help
let g:bufExporerShowRelativePath=1  "Show relative paths
let g:bufExporersortBy='mru'        "Sort by most recently used
let g:bufExporerSplitRight=0        "Split left
let g:bufExporerSplitVerTical=1     "Split vertical
let g:bufExporerSplitVerTSize=25    "Split width
let g:bufExporerUseCurrentWindow=1  "Open in new window
map <silent> <leader>hb :HSBufExplorer<cr>

"=============================================================================
"MiniBufExplorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mbt mbe mbc mbu
"map <silent> <leader>mbc ,mbe:q!<cr>

"=============================================================================
"WinManager ����:���Ƹ�����Ĵ��ڲ���
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:winManagerWindowLayout="BufExplorer|TagList"
let g:winManagerWindowLayout='FileExplorer|BufExplorer'
let g:persistentBehaviour=0		"ֻʣһ������ʱ, �˳�vim.
let g:winManagerWidth=26
let g:defaultExplorer=1
nmap <silent> <leader>fir :FirstExplorerWindow<cr>
nmap <silent> <leader>bot :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>

"=============================================================================
" c.vim settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if MySys() == 'linux'
    let g:C_GlobalTemplateFile =
\   "/usr/local/share/vim/vimfiles/c-support/templates/Templates"
elseif MySys() == 'windows'
    let g:C_GlobalTemplateFile =
\   "C:\\vim\\Vim\\vimfiles\\c-support\\templates\\Templates"
endif
let g:C_Ctrl_j = "on"
"
"  g:C_CodeSnippets           plugin_dir."/c-support/codesnippets/"
"  g:C_Dictionary_File        ""
"  g:C_LoadMenus              "yes"
"  g:C_MenuHeader             "yes"
"  g:C_OutputGvim             "vim"
"  g:C_XtermDefaults          "-fa courier -fs 12 -geometry 80x24"
"  g:C_Printheader            "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
"  g:C_MapLeader              '\'
"
"  Linux/UNIX:
"   g:C_ObjExtension          ".o"
"   g:C_ExeExtension          ""
"   g:C_CCompiler             "gcc"
"   g:C_CplusCompiler         "g++"
"   g:C_Man                   "man"
"  Windows:
"   g:C_ObjExtension          ".obj"
"   g:C_ExeExtension          ".exe"
"   g:C_CCompiler             "gcc.exe"
"   g:C_CplusCompiler         "g++.exe"
"   g:C_Man                   "man.exe"
"  g:C_CFlags                 "-Wall -g -O0 -c"
"  g:C_LFlags                 "-Wall -g -O0"
"  g:C_Libs                   "-lm"
"  g:C_LineEndCommColDefault  49
"  g:C_CExtension             "c"
"  g:C_TypeOfH                "cpp"
"  g:C_SourceCodeExtensions   "c cc cp cxx cpp CPP c++ C i ii"
"
"  g:C_CodeCheckExeName       "check"
"  g:C_CodeCheckOptions       "-K13"

"=============================================================================
" omnicppcomplete.vim settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"���в�ȫ                        CTRL-X CTRL-L
"���ݵ�ǰ�ļ���ؼ��ֲ�ȫ        CTRL-X CTRL-N
"�����ֵ䲹ȫ                    CTRL-X CTRL-K
"����ͬ����ֵ䲹ȫ              CTRL-X CTRL-T
"����ͷ�ļ��ڹؼ��ֲ�ȫ          CTRL-X CTRL-I
"���ݱ�ǩ��ȫ                    CTRL-X CTRL-]
"��ȫ�ļ���                      CTRL-X CTRL-F
"��ȫ�궨��                      CTRL-X CTRL-D
"��ȫvim����                     CTRL-X CTRL-V
"�û��Զ��岹ȫ��ʽ              CTRL-X CTRL-U
"ƴд����                        CTRL-X CTRL-S
set completeopt=longest
" CTRL-X CTRL-O ȫ�ܲ�ȫ, ��"CTRL-E"ֹͣ��ȫ���ص�ԭ��¼������֡���"CTRL-Y"��
" ��ֹͣ��ȫ�������ܵ�ǰ��ѡ����Ŀ
"map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"map <F11> :!ctags -R <CR>
" ��һ�в�������, Ϊʲô��?????
"inoremap <C-D> <C-X><C-F>
"inoremap <expr> <C-J>    pumvisible() ? "\<PageDown>\<C-N>\<C-P>" : "\<C-X><C-O>"
"inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
"inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
"inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
"inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowPrototypeInAbbr = 0 " 1: ��ʾ����ǩ��
let OmniCpp_ShowAccess = 1 " �Ƿ���ʾ����
let OmniCpp_MayCompleteScope = 0 " ::���Ƿ񵯳�
let OmniCpp_ShowScopeInAbbr = 0 " 1: ������ ����/������;  0: �෴
"0 = don't select first popup item
"1 = select first popup item (inserting it to the text)
"2 = select first popup item (without inserting it to the text)
let OmniCpp_SelectFirstItem = 2
"0 = use standard vim search function
"1 = use local search function
let OmniCpp_LocalSearchDecl = 1

"=============================================================================
" DoxygenToolkit.vim �ĵ�����
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ȫ��������Ͷ�Ӧ�Ľ���:
" Dox                       Function / class comment
" DoxLic                    License
" DoxAuthor                 DoxAuthor
" DoxBlock                  Group
" DoxUndoc(DEBUG) !         Ignore code fragment
let g:DoxygenToolkit_commentType = "C"
let g:DoxygenToolkit_briefTag_pre="@Description:  "
let g:DoxygenToolkit_paramTag_pre="@Param "
let g:DoxygenToolkit_returnTag="@Returns:   "
let g:DoxygenToolkit_blockHeader="************************************************************************"
let g:DoxygenToolkit_blockFooter="************************************************************************"
let g:DoxygenToolkit_authorName="nuoerll (nuoliu), lcy3636@126.com"
let g:DoxygenToolkit_licenseTag="Reserve"
"nmap <silent> <leader>dox :Dox<cr><esc>mzkddk3lvf/r*f<space>D0%ddr*wh.f<space>D`za
"nmap <silent> <leader>dox :Dox<cr><esc>mzkddk2lvf/r=xxf<space>D0%ddr*llvf/hhr=f<space>D`za
nmap <silent> <leader>dox :Dox<cr><esc>mzkddk2lvf/r=xf<space>Dr*0%hmxl
\<C-E>%lr*hj<C-E>`xjr<space>`xjllvf/hr=f<space>Dhr*`za<C-W>:<Tab>

"=============================================================================
" winmove.vim	settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:wm_move_x = 85
let g:wm_move_y = 20

"=============================================================================
" a.vim	settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>ihh :IH<cr>
nmap <silent> <leader>ihs :IHS<cr>
nmap <silent> <leader>ihv :IHV<cr>
"	a.vim��Ҫ��������:
"		:A switches to the header file corresponding to the current file being edited (or vise versa)
"		:AS splits and switches
"		:AV vertical splits and switches
"		:AT new tab and switches
"		:AN cycles through matches
"		:IH switches to file under cursor
"		:IHS splits and switches
"		:IHV vertical splits and switches
"		:IHT new tab and switches
"		:IHN cycles through matches
"		<Leader>ih switches to file under cursor
"		<Leader>is switches to the alternate file of file under cursor (e.g. on  <foo.h> switches to foo.cpp)
"		<Leader>ihn cycles through matches

"=============================================================================
" VisualMark.vim���
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VisualMark.vim�����Ҫ��������:
		" 1.  For gvim, use "Ctrl + F2" to toggle a visual mark.
		"     For both vim and gvim, use "mm" to toggle a visual mark.
		" 2.  Use "F2" to navigate through the visual marks forward in the file.
		" 3.  Use "Shift + F2" to navigate backwards.
" ��ӦVisualMark�е���������:
	"  map <unique> <c-F2> <Plug>Vm_toggle_sign
	"  map <silent> <unique> mm <Plug>Vm_toggle_sign
	"  map <unique> <F2> <Plug>Vm_goto_next_sign
	"  map <unique> <s-F2> <Plug>Vm_goto_prev_sign

"=============================================================================
" Mark.vim���
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mark.vim�е���������:
    "nmap <unique> <silent> <leader>m <Plug>MarkSet " mark or unmark the word
"under (or before) the cursor
    "nmap <unique> <silent> <leader>r <Plug>MarkRegex  "manually input a
"regular expression. ��������.
    "nmap <unique> <silent> <leader>c <Plug>MarkClear " clear this mark (i.e.
"the mark under the cursor), or clear all highlighted marks .
	"nnoremap <silent> <leader>* :call <sid>SearchCurrentMark()<cr>
	"nnoremap <silent> <leader># :call <sid>SearchCurrentMark("b")<cr>
	"nnoremap <silent> <leader>/ :call <sid>SearchAnyMark()<cr>
	"nnoremap <silent> <leader>? :call <sid>SearchAnyMark("b")<cr>
	"nnoremap <silent> * :if !<sid>SearchNext()<bar>execute "norm! *"<bar>endif<cr>
	"nnoremap <silent> # :if !<sid>SearchNext("b")<bar>execute "norm! #"<bar>endif<cr>
	"command! -nargs=? Mark call s:DoMark(<f-args>)

"=============================================================================
" code_complete.vim���
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab           " ���ɲ�����ʾ��Ϣ
" Ctar + j      " ������һ��������

"=============================================================================
" pyclewn settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"C-B : break "${fname}":${lnum} # set breakpoint at current line
"C-D : down
"C-E : clear "${fname}":${lnum} # clear breakpoint at current line
"C-N : next
"C-P : print ${text}            # print value of selection at mouse position
"C-U : up
"C-X : print *${text}           # print value referenced by word at mouse position
"C-Z : sigint                   # kill the inferior running program
"S-A : info args
"S-B : info breakpoints
"S-C : continue
"S-F : finish
"S-L : info locals
"S-Q : quit
"S-R : run
"S-S : step
"S-W : where
"S-X : foldvar ${lnum}          # expand/collapse a watched variable
map <silent> <leader>exl :C target exec Example.exe<CR>
map <silent> <leader>efl :C file Example.exe <CR>
"nmap <silent> <C-B> :call <SID>Breakpoint("break")<CR>
":map <F8> :exe "Cbreak " . expand("%:p") . ":" . line(".")<CR>
"map <F7> :exe "Cbreak " expand("%") ":" . line(".")<CR>
map <F8> :exe "Cclear " expand("%") ":" . line(".")<CR>
map <F9> :exe "C p " expand("<cword>") <CR>
map <F10> :exe "C p " expand("<cWORD>") <CR>
"map <F11> :exe "Cfoldvar " . line(".")<CR>
map <silent> <leader>eib :exe "C info breakpoints"<CR>
map <silent> <leader>efn :exe "C finish"<CR>
map <silent> <leader>eru :exe "C run"<CR>
map <silent> <leader>ede :C delete
map <silent> <leader>efi :C file
map <silent> <leader>eex :C target exec
map <silent> <leader><space><space> q:
"vnoremap <C-N> :exe "C n"<CR> alt
nmap <silent> <C-N> :exe "C n"<CR>
"nmap <silent> <C-S> :exe "C s"<CR>
nmap <silent> <C-C> :exe "C c"<CR>
nmap <silent> <leader>ezo :exe "Cfoldvar " . line(".")<CR>

"=============================================================================
" project.vim   project.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>pr :Project Project<CR> zR
" �л��򿪺͹ر�project����
nmap <silent> <Leader>P <Plug>ToggleProject
"�����Ŀ���ڿ��.    Ĭ��ֵ: 24
let g:proj_window_width=24
"�����ո��<space>���ߵ���������<LeftMouse>ʱ��Ŀ���ڿ��������,Ĭ��ֵ:100
let g:proj_window_increment=90
let g:proj_flags='i'    "��ѡ���һ���ļ�ʱ������������ʾ�ļ����͵�ǰ����·��.
"�ڳ���ģʽ�¿��� |CTRL-W_o| �� |CTRL-W_CTRL_O| ӳ��, ʹ�õ�ǰ��������ΪΨһ��
"���Ļ�����, ������Ŀ������Ȼ�ɼ�.
let g:proj_flags='m'
let g:proj_flags='t'    "�ð� <space> ���д��ڼӿ�.
let g:proj_flags='F'   "��ʾ������Ŀ����. �رմ��ڵ��Զ�������С�ʹ����滻.
let g:proj_flags='L'    "�Զ�����CD�����л�Ŀ¼.
"let g:proj_flags='n'    "��ʾ�к�.
let g:proj_flags='T'    "����Ŀ���۵��ڸ���ʱ������ڵ�ǰ�۵��·���ʾ(��������ײ�).
let g:proj_flags='v'    "���ú�, �� \G ����ʱ�� :vimgrep ȡ�� :grep.
let g:proj_flags='c'    "���ú�, ����Ŀ�����д��ļ�����Զ��ر���Ŀ����.
let g:proj_flags='S'    "��������.
let g:proj_flags='s'    "�����﷨����.
"let g:proj_run1='!p4 edit %f'      "g:proj_run1 ...  g:proj_run9 �÷�.
let g:proj_run3='silent !gvim %f'
"let g:proj_run4="echo 'Viewing %f'|sil !xterm -e less %f & & pause"
"
"MAPPINGS                            *project-mappings*
""ӳ��                        ���� ~
"\r        ���ݹ��˷����¹�괦����Ŀ.�����һ�����ʹ����"#pragmakeep"(����
           "˫����),��ô���н�����,
"\R        �ݹ�ִ��\r.
"\c        ����һ����Ŀ.����ʹ��|netrw|�������Ŀ������.
"\C        ΪĿ¼������Ŀ¼�µ��ļ��ݹ鴴��һ����Ŀ.
"<Return>  ��ǰһ���ڻ�������һ���´����д򿪹�괦���ļ�.������λ���۵���
"<space>   ���˼��������С�������.
"<S-Return>
"\s        ��<Return>һ��,����ˮƽ�ָ�Ŀ�괰��.
"\S        ���������ļ�����ǰ����,��ǰ���ڻᱻˮƽ�ָ���ʾ�����ļ�.
"<C-Return>
"\o        ͬ<Return>��һ�������д򿪵�ǰ�ļ�,ͬʱ�ر��������д򿪵Ĵ���.
"<M-Return>
"\v        ͬ<Return>������ʾ�ļ�����,�������Ȼͣ������Ŀ������.
"<CTRL-Up>
"\<Up>     �ƶ��ı������۵�����ǰ������һ��.���е��ն��п����޷�ʶ��˰󶨶�ʧЧ
"<CTRL-Down>
"\<Down>
"          �ƶ��ı������۵�����ǰ������һ��.���е��ն��п����޷�ʶ��˰󶨶�ʧЧ
"\i        ��״̬������ʾ��������۵���ȫ�����ͼ̳еĲ���.
"\I        ��״̬����ʾ������ļ�����ȫ��(��·��).�˹����ǲ������
"\l        ���ص�ǰ��Ŀ�е������ļ���Vim��,�ڼ��ع����а��κμ�����ֹͣ����.
"\w        ɾ����ǰ��Ŀ����е������ļ�.(��������ɾ���ļ�,ֻ��Ը���Ŀ��֯����.
"\W        ɾ����ǰ��Ŀ�㼰���Ӳ���е������ļ�.(��������ɾ���ļ�,ֻ��Ը���Ŀ��
"\g        ������ǰ��Ŀ�������ļ�.
"
"# pragma keep     "�����һ�����ʹ���� # pragma keep, ��ô���н�����, ���ᱻ
"�ڸ���ʱ��ɾ��.
"change the Project File, do a :bwipe in the Project Buffer, then re-invoke.

"=============================================================================
"NERD_tree.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let loaded_nerd_tree=1    " ����������NERD_tree�йص�����
nmap <silent> <leader>tto :NERDTreeToggle<cr>
let NERDTreeIgnore=['\.vm$', '\~$']    " ����ʾָ�������͵��ļ�
let NERDTreeShowHidden=0    " ����ʾ�����ļ�(����ֻ��linux��������Ч)
let NERDTreeSortOrder=['\/$','\.cpp$','\.c$', '\.h$','\.java','.class','*']    " ����
let NERDTreeCaseSensitiveSort=0     " ���ִ�Сд����
let NERDTreeWinSize=23
" let NERDTreeShowLineNumbers=1
let NERDTreeShowBookmarks=1
let NERDTreeQuitOnOpen=0    " 1: ���ļ���, �ر�NERDTrre����
" let NERDTreeHighlightCursorline=1     " ����NERDTrre���ڵĵ�ǰ��
" nmap <silent> <leader>tmk :Bookmark expand("<cword>")<cr>  "

"=============================================================================
" NERD_commenter.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <leader>ccc ,cc<cr>k
imap <silent> <leader>ccc /*<esc>a
map <silent> <leader>cca ,ca<cr>k
map <silent> <leader>ccs mz:.,.s/ //g<cr>/<Up><Up><cr>`z
vnoremap <silent> <leader>scs :s/ //g<cr>
vmap <silent> <leader>ct :s/\( .*$\)/ (\^\1\^)<cr>
"map <silent> <leader>ct $F!,c$<cr>k$F!x
map <silent> <leader>ct $F<space>l,c$<cr>k$2F<space>l
map <silent> <leader>cis :source $VIM/vimfiles/syntax/txt.vim<cr>
"map <silent> <leader>cqt qa,ctjq10@a
"map <F2> $F<space>l,c$<cr>k
"let NERD_java_alt_style=1
" Default mapping: [count],cc   " ����Ϊ��λ����ע��.
" ,c<space>     " comment <--> uncomment.
" ,cm           " �Զ���Ϊ��λ����ע��.
" ,cs           " �������ʽע��.
" ,cy           " Same as ,cc except that the commented line(s) are yanked first.
" ,c$           " ע�͵�ǰ��굽��δ������.
" ,cA           " ����β�����ֶ�����ע������.
" ,ca           " �л�ע�ͷ�ʽ(/**/ <--> //).
" ,cl           " Same cc, ���������.
" ,cb           " Same cc, �������˶���.
" ,cu           " Uncomments the selected line(s).
"

"=============================================================================
" sketch.vim   ���������
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <leader>stc :call ToggleSketch()<CR>

"=============================================================================
" javacomplete.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au FileType java imap <silent> <leader>. :<C-X> <C-O>
setlocal completefunc=javacomplete#CompleteParamsInfo
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType java set omnifunc=javacomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

"=============================================================================
" Calendar.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"map <silent> <leader>cal :Calendar<cr>
map <silent> <leader>cah :CalendarH<cr>

"=============================================================================
" JumpInCode_Plus.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader>jc  Generate tags and cscope database from current directory to :
                 "CurrentDirectory/OutDB/cscope.out,tags
" <leader>jst       list existed tags full name and choose tags
" <leader>jsc      list existed cscope database full name and choose cscope.out
" ��ʾ�����ӵ����ݿ�
map <silent> <leader>jlt :set tags<cr>
map <silent> <leader>jlc :cs show<cr>

"=============================================================================
" txtbrowser.zip
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"plain text brower(show the document map and syntax highlight in plain text)
"help txt-keywords
"�Կո��ͷ, ����ؼ���"figure"���ж���Ϊ"�ı�ͼ",���н�������taglist������.
"�Կո��ͷ, ����ؼ���"table"���ж���Ϊ"�ı���",���н�������taglist������.
map <silent> <leader>bft :set ft=txt<cr>
"<Leader>g / TxtBrowserUrl		"��URL
"<Leader>f / TxtBrowserWord		"�鵥��
"<Leader>s / TxtBrowserSearch	"search word under cursor
map <silent> <leader>bgu :TxtBrowserUrl<cr>
map <silent> <leader>bfw :TxtBrowserWord<cr>
map <silent> <leader>bsw :TxtBrowserSearch<cr>
let tlist_txt_settings = 'txt;c:content;f:figures;t:tables'
let TxtBrowser_Dict_Url='http://dict.cn/text'	"Ӣ�Ĵʵ�
let Txtbrowser_Search_Engine='http://www.baidu.com/s?wd=text&oq=text&f=3&rsp=2'
au BufRead,BufNewFile *.txt setlocal ft=txt "syntax highlight txt for txt.vim
"au BufRead,BufNewFile *.log setlocal ft=txt "syntax highlight log for txt.vim
au BufRead,BufNewFile *log setlocal ft=txt "syntax highlight log for txt.vim

"=============================================================================
" ZoomWin.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Press <c-w>o : the current window zooms into a full screen
" Press <c-w>o again: the previous set of windows is restored

"=============================================================================
" FindMate.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ���ٲ����ļ�
" You can launch FindMate by typing:
"       ,, File_name
" Or
"       :FindMate File_name
" The shortcut can be redefined by using:
"       map your_shortcut   <Plug>FindMate
" In your .vimrc file

"=============================================================================
" grep.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"=============================================================================
" vimdiff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"�������Ƿ�ͬʱ����
map <silent> <leader>sc :set scrollbind<cr>
map <silent> <leader>nsc :set noscrollbind<cr>
"vimdiff�ļ��Ƚ�,��λ���ļ���ͬ��, <��ǰ, ���>
map <silent> <leader>w ]c<cr>
map <silent> <leader>s [c<cr>

"=============================================================================
" quickfix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"����quickfix(gcc make),�����õ����������ӳ��
autocmd FileType c,cpp,h map <buffer> <leader><space> :w<cr>:make<cr>:cw 10<cr>:cn<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr> :cn<cr>
"######################## end of plugins #####################################



"#############################################################################
" ��Ŀ������� pj
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set path+=./**

":cd src                            "�л���/home/easwy/src/vim70/srcĿ¼
":set sessionoptions-=curdir        "��session option��ȥ��curdir
":set sessionoptions+=sesdir        "��session option�м���sesdir
":mksession vim70.vim               "����һ���Ự�ļ�
":wviminfo vim70.viminfo            "����һ��viminfo�ļ�
":qa                                "�˳�vim

"��vim����Ự�ļ������һ��, �������һ��������ļ�(*x.vim)��ִ�����е�ex����.
"Ȼ���ٱ༭һ����Ϊ~/src/vim70/vim70x.vim (*x.vim) ���ļ����ļ�������Ϊ:
""set project path
"set path+=~/src/vim70/** 

"�˳�vim������������ִ��gvim &���ٴν���vim����ʱ��������һ���հ״��ڡ�Ȼ��ִ����������
":source ~/src/vim70/src/vim70.vim  '����Ự�ļ�
":rviminfo vim70.viminfo            '����viminfo�ļ�


" execute project related configuration in current directory
if filereadable("workspace.vim")
    source workspace.vim
endif 
if filereadable("vim72_wp.vim")
   source vim72_wsp.vim
endif



"#############################################################################
"maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for jsp jsps
map <silent> <leader>utf mz:%s/GB2312/UTF-8/gi<cr>`z
map <silent> <leader>b23 mz:%s/utf-8/GB2312/gi<cr>`z
map <silent> <leader>sps gg0:w <C-R><C-W>.jsp<cr>,cccjfGcwutf-8<esc>
map <silent> <leader>sfj mzgg0W :call Firefox_jsp()<cr>`z

" for shell-script
map <silent> <leader>ssa gg/^$<cr>qz"apjjf"mzggjlv$hy*`zpjqi
map <silent> <leader>ssb gg/^$<cr>qz"bpjjf"mzggjlv$hy*`zpjqi
map <silent> <leader>sss gg/#!<cr>h<C-E>G0dkddkddpi#<esc>

map <silent> <leader>d2s :%s/��/, /ge<cr>:%s/��/. /ge<cr>:%s/��/; /ge<cr>
\:%s/��/: /ge<cr>:%s/��/  /ge<cr>:%s/��/"/ge<cr>:%s/��/"/ge<cr>:%s/��/?/ge<cr>
\:%s/��/!/ge<cr>:%s/��/,/ge<cr>:%s/��/)/ge<cr>:%s/��/(/ge<cr>:%s/��/.../ge<cr>
\:%s/��/=/ge<cr>:%s/��/\//ge<cr>:%s/��/\*/ge<cr>:%s/��/-/ge<cr>:%s/��/#/ge<cr>
\:%s/��/1/ge<cr>:%s/��/2/ge<cr>:%s/��/-/ge<cr>
":%s/��/1/ge<cr>
map <silent> <leader>s2t :%s/	/    /g<cr>
map <silent> <leader>pwd :pwd<cr>
map <silent> <leader>y mz:r!cat /tmp/pwd2vim.tmp<cr>0vEd`zi <esc>Pjdd`zf<Space>x
map <F3> :tabclose<CR>
map <F4> :tabnew<CR>
map <F5> :tabprevious<CR>
map <F6> :tabnext<CR>
"-------------------------�������--------------------------------------------
"�ı䴰�ڸ߶�, ���
noremap <silent> <leader>wi 10<C-W>+
noremap <silent> <leader>wd 10<C-W>-
noremap <silent> <leader>vwi 18<C-W>>
noremap <silent> <leader>vwd 18<C-W><
"�ƶ�����λ��
noremap <silent> <leader>mr <C-W>R
noremap <silent> <leader>mh <C-W>H
noremap <silent> <leader>mk <C-W>K
noremap <silent> <leader>mj <C-W>J
noremap <silent> <leader>ml <C-W>L
"ƽ�����д��ڴ�С
noremap <silent> <leader>mq <C-W>=
"�ڴ��ڼ��ƶ���꽹��
noremap <silent> <leader>sh <C-W>h
noremap <silent> <leader>sk <C-W>k
noremap <silent> <leader>sj <C-W>j
noremap <silent> <leader>sl <C-W>l
map <silent> <leader>nww :split<cr>
noremap <C-Q>		:close<cr>
" ��ֻʣ��һ������ʱ, ���ܹر�
map <silent> <leader>clo :close<cr>
"only retain one splip window
map <silent> <leader>onl :only<cr>
"��һ���´���
map <silent> <leader>new :new<cr>
"��ֱ�ָ��
map <silent> <leader>vnw :vsplit<cr>
map <silent> <leader>vne :vnew<cr>
"-------------------------end of �������---------------------------------
map <silent> <leader>afg A @@@@@<esc>
map <silent> <leader>dfg $bhde<esc>
" �ӹ�����ڵ��п�ʼ, ����һ�����м�������н�������
map <silent> <leader>sfl :.,/^$/-1!sort<cr>
map <silent> <leader>sor :!sort<cr>
" ��ѡ�������еĿ���ɾ����
map <silent> <leader>dsp :g/^$/d<cr>
" ɾ��ѡ����������ĩ�ո�
map <silent> <leader>dep :%s/  *$//g<cr>
" �����к�
map <silent> <leader>anu :%s/^/\=line(".")." "/g<cr>
" �ַ���
map <silent> <leader>coc :%s/./&/gn<cr>
" ������
map <silent> <leader>cow :%s/\i\+/&/gn<cr>
" ����
map <silent> <leader>col :%s/^//n<cr>
" ͳ�ƹ���µ��������г��ֵĴ���
map <silent> <leader>cos :%s/\<<C-R><C-W>\>/&/gn<cr>
map <silent> <leader>cos :%s/<C-R><C-W>/&/gn<cr>
" \ ==> /
map <silent> <leader>tof V:s/\\/\//g<cr>
" source $VIMRUNTIME/syntax/2html.vim
map <silent> <leader>v2h :source $VIMRUNTIME/syntax/2html.vim<cr>
" write date under cursor
map <silent> <leader>dte :r ! date<cr>I(<Esc>A)<Esc>o<Esc>i#<esc>77a=<Esc>0
"��ĳ�����ʼ���()
map <silent> <leader>eas i(<Esc>ea)<Esc>
map <silent> <leader>eam i[<Esc>ea]<Esc>
map <silent> <leader>eab i{<Esc>ea}<Esc>
map <silent> <leader>bas i(<Esc>$a)<Esc>
map <silent> <leader>bam i[<Esc>$a]<Esc>
map <silent> <leader>bab i{<Esc>$a}<Esc>
map <silent> <leader>g %
map <silent> <leader>hh [[
map Q gq
map <silent> <leader>lhd o<Esc>I#ifdef  _NAL_HDEBUG_<Esc>o#else<Esc>o#endif
"In order to use "p" in visual mordel
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>
"����Ҳ���Դ�78���ַ�ʱ�Զ�����
map <silent> <leader>sfo :set fo+=Mm<cr>
map <silent> <leader>q :set noai<cr>:set fo+=Mm<cr>Vgq:set ai<cr>
inoremap <C-U> <C-G>u<C-U>
"########################end of map##########################################



"#############################################################################
" some settings for windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x
" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+
" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>
" Use CTRL-E to do what CTRL-V used to do
"ѡ�п�
noremap <C-E>		<C-V>
" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>
" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif
" CTRL-Z is Undo; not in cmdline though
"noremap <C-Z> u
"inoremap <C-Z> <C-O>u
" CTRL-Y is Redo (although not repeat); not in cmdline though
"noremap <C-Y> <C-R>
"inoremap <C-Y> <C-O><C-R>
" Alt-Space is System menu
if has("gui")
    noremap <M-Space> :simalt ~<CR>
    inoremap <M-Space> <C-O>:simalt ~<CR>
    cnoremap <M-Space> <C-C>:simalt ~<CR>
endif
"�Թ���µ�������1
noremap <M-C-A> <C-A>
"�Թ���µ����ּ�1
noremap <M-C-X> <C-X>
" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
"cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG
" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w
" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c
" restore 'cpoptions'
"set cpo&
"if 1
"  let &cpoptions = s:save_cpo
"  unlet s:save_cpo
"endif
"######################## end of windows settings ############################




"#############################################################################
" notes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"*Q_fo*		Folding
"Q_re
"i_CTRL-R
"-----------------------------------------------------------------------------
"|:dig|	   :dig[raphs]		show current list of digraphs
"|i_CTRL-K|	CTRL-K {char1} {char2}
"-----------------------------------------------------------------------------
"|:r!|	   :r! {command}   insert the standard output of {command} below the cursor
"-----------------------------------------------------------------------------
"|quote|	  "{char}	use register {char} for the next delete, yank, or put
"-----------------------------------------------------------------------------
"   "ay     "ap
"-----------------------------------------------------------------------------
"|:ce|	  :[range]ce[nter] [width]      center the lines in [range]
"|:le|	  :[range]le[ft] [indent]       left-align the lines in [range] (with [indent])
"|:ri|	  :[range]ri[ght] [width]       right-align the lines in [range]
"-----------------------------------------------------------------------------
"|&|	      &		Repeat previous ":s" on current line without options
"-----------------------------------------------------------------------------
"Q_to
"|v_a'|	   N  a'	Select "a single quoted string"
"|v_i'|	   N  i'	Select "inner single quoted string"
"|v_aquote| N  a"	Select "a double quoted string"
"|v_iquote| N  i"	Select "inner double quoted string"
"|v_a`|	   N  a`	Select "a backward quoted string"
"|v_i`|	   N  i`	Select "inner backward quoted string"
"-----------------------------------------------------------------------------
"|ga|		   ga		show ascii value of character under cursor in decimal, hex, and octal
"|g8|		   g8		for utf-8 encoding: show byte sequence for character under cursor in hex.
"-----------------------------------------------------------------------------
"|ZZ|	     ZZ			Same as ":x".
"|ZQ|	     ZQ			Same as ":q!".
"|:stop|	  :st[op][!]		Suspend VIM or start new shell.  If 'aw' option
"|CTRL-Z|     CTRL-Z		Same as ":stop"
"-----------------------------------------------------------------------------
"|CTRL-W_]|	CTRL-W ]		Split window and jump to tag under cursor
"|CTRL-W_f|	CTRL-W f		Split window and edit file name under the cursor
"|CTRL-W_^|	CTRL-W ^		Split window and edit alternate file
"|CTRL-W_n|	CTRL-W n  or  :new	Create new empty window
"|CTRL-W_q|	CTRL-W q  or  :q[uit]	Quit editing and close window
"|CTRL-W_c|	CTRL-W c  or  :cl[ose]	Make buffer hidden and close window
"|CTRL-W_o|	CTRL-W o  or  :on[ly]	Make current window only one on the screen
"|CTRL-W_j|	CTRL-W j		Move cursor to window below
"|CTRL-W_k|	CTRL-W k		Move cursor to window above
"|CTRL-W_CTRL-W|	CTRL-W CTRL-W		Move cursor to window below (wrap)
"|CTRL-W_W|	CTRL-W W		Move cursor to window above (wrap)
"|CTRL-W_t|	CTRL-W t		Move cursor to top window
"|CTRL-W_b|	CTRL-W b		Move cursor to bottom window
"|CTRL-W_p|	CTRL-W p		Move cursor to previous active window
"|CTRL-W_r|	CTRL-W r		Rotate windows downwards
"|CTRL-W_R|	CTRL-W R		Rotate windows upwards
"|CTRL-W_x|	CTRL-W x		Exchange current window with next one
"|CTRL-W_=|	CTRL-W =		Make all windows equal height
"|CTRL-W_-|	CTRL-W -		Decrease current window height
"|CTRL-W_+|	CTRL-W +		Increase current window height
"|CTRL-W__|	CTRL-W _		Set current window height (default:
"-----------------------------------------------------------------------------
"C-W    C-U     C-E     C-U
"-----------------------------------------------------------------------------
"���� CTRL-R {register} ����Ĵ���������ݡ������ô������㲻�ؼ��볤�ʡ����磬
"-----------------------------------------------------------------------------
" �༭�������ļ�
" vim -b file     %!xxd �л�Ϊʮ������
"-----------------------------------------------------------------------------
" �Ѯ�ǰ�ļ�����һ��, ����Y����A.txt
"map <silent> <leader>no :A.txt<esc>
"-----------------------------------------------------------------------------
" ��Сдת��
" gu gU
" guW guw  ��Ӧһ��
" guE gue  ��Ӧһ��
" guU guu  ��Ӧһ��
" gggUG gggug  ��Ӧһ���ļ�
"-----------------------------------------------------------------------------
"ʵ����vim�Զ�����һ���������е�����:
"	 i2.<esc>
"	 qa
"	 yyp<C-a>q
"	 98@a
"-----------------------------------------------------------------------------
"˫��m������ɾ��Win�����ɵĶ��໻�з�CR����Vim�п��Կ�����ɫ��^M��
"nmap mm :%s/\r//g<cr>
"-----------------------------------------------------------------------------
"˫��t��ʵ�ֶ���������ص�TXT�ı������Ű沢ɾ���������Ĺ���
"nmap tt :%s/^\([\s��]\+\)/    /g<cr>:%s/^����ʱ��.*\d$//g<cr>:%s/<a href.*<\/a>$//g<cr>:%s/\([\s��]*\n\)\+/\r\r/<cr>
"-----------------------------------------------------------------------------
"vimgrep ��ʹ��
":cd ~/src/vim70
":vimgrep /\<main\>/ src/*.c
":cw 
"-----------------------------------------------------------------------------
":Explore"��Ex���������ļ������
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"-----------------------------------------------------------------------------
"######################## end of notes #######################################
"
"set sessionoptions+=slash
