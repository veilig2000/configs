scriptencoding utf-8
" ^^ Please leave the above line at the start of the file.

" Default configuration file for Vim
" $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/files/vimrc-r3,v 1.1 2006/03/25 20:26:27 genstef Exp $

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
set fileencodings+=default
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on

  " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
  " indent settings. Some people don't like these, so we won't turn them on by
  " default.
  " filetype indent on
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
  if executable("/bin/bash")
    set shell=/bin/bash
  elseif executable("/bin/sh")
    set shell=/bin/sh
  endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :

set nowrap

"source /home/veilig/.vim/plugin/word_complete.vim
"call DoWordComplete()

source /home/veilig/.vim/plugin/AutoAlign.vim
source /home/veilig/.vim/plugin/AlignMaps.vim
source /home/veilig/.vim/plugin/AlignPlugin.vim
source /home/veilig/.vim/plugin/cecutil.vim
source /home/veilig/.vim/plugin/php.vim

let g:C_AuthorName	= 'Jamie Kahgee'
let g:C_AuthorRef	= 'JMK'
let g:C_Email		= 'jamie@gmail.com'
let g:C_Company		= 'Atlantic BT'

set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set clipboard=unnamed

map <c-t><c-l> :TlistToggle<CR>
map <c-m><c-t> :!/usr/bin/ctags -R --php-kinds=-j --fields=+ias --extra=+q .<CR>
map <c-f><c-n> :echo expand('%:p')<CR>
map  :set wrap<CR>
map  :set nowrap<CR>
map  O<ESC>0i/*<ESC>
map  o<ESC>0i*/<ESC>
map  <ESC>0i//<ESC>
noremap ;; :%s:::g<Left><Left><Left>
noremap ;' :%s:::cg<Left><Left><Left><Left>

au bufread *.phtml set ft=php
au bufread *.phtml setf=php
set foldmethod=marker
set incsearch
"Set the view to be exactly the same after we close a file
"so the next time we open it; fold, etc.. will be in the same status
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

"Make working directory the same as the buffer you are editing
autocmd BufEnter * lcd %:p:h

"Delete trailing whitespace before saving
autocmd BufWritePre * :%s/\s\+$//e

autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e

source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

"Map the sql query formatter to sf in visual mode
vmap <silent>sf<CR> :emenu Plugin.SQLUtil.Format\ Statement<CR>
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
set tags=tags;/

set tpm=999

nmap <silent> <RIGHT>        :cnext<CR>
nmap <silent> <RIGHT><RIGHT> :cnfile<CR><C-G>
nmap <silent> <LEFT>         :cprev<CR>
nmap <silent> <LEFT><LEFT>   :cpfile<CR><C-G>

augroup HelpInTabs
    autocmd!
    autocmd BufEnter *.txt call HelpInNewTab()
augroup END

function! HelpInNewTab ()
    if &buftype == 'help'
        execute "normal \<C-W>T"
    endif
endfunction

nnoremap <SPACE> <PAGEDOWN>
nmap <silent> ;v :next $MYVIMRC<CR>
augroup VimReload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

set undolevels=5000

if has('persistent_undo')
    set undofile
endif

set undodir=$HOME/tmp/.VIM_UNDO_FILES

" Remap the undo key to warn about stepping back into a buffer's pre-history...
nnoremap <expr> u VerifyUndo()
" Track each buffer's starting position in undo history...
augroup UndoWarnings
    autocmd!
    autocmd BufReadPost,BufNewFile *
    \ :call Rememberundo_start()
augroup END

function! Rememberundo_start ()
    let b:undo_start = exists('b:undo_start')
    \ ? b:undo_start
    \ : undotree().seq_cur
endfunction

function! VerifyUndo ()
    " Are we back at the start of this session
    " (but still with undos possible)???
    let undo_now = undotree().seq_cur

    if undo_now > 0 && undo_now == b:undo_start
        " If so, ask whether to undo into pre-history...
        return confirm('',
        \ "Undo into previous session? (&Yes\n&No)",1) == 1
        \ ? "\<C-L>u" : "\<C-L>"
    endif
    " Otherwise, just undo...
    return 'u'
endfunction

set virtualedit=block

"vmap <expr> > ShiftAndKeepVisualSelection(">")
"vmap <expr> < ShiftAndKeepVisualSelection("<")
"
"function! ShiftAndKeepVisualSelection(cmd, mode)
"    set nosmartindent
"    if mode() =~ '[Vv]'
"        return a:cmd . ":set smartindent\<CR>gv"
"    else
"        return a:cmd . ":set smartindent\<CR>"
"    endif
"endfunction

set smartcase ignorecase

nmap <DEL> :nohlsearch<CR>

autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$")
\|  exe "normal! g`\""
\| endif

nmap S :%s///g<LEFT><LEFT><LEFT>
vmap S :///g<LEFT><LEFT><LEFT>
highlight Search ctermfg=White ctermbg=Red
" Toggle on and off...
nmap <silent> <expr>  fszz FS_ToggleFoldAroundSearch({'context':1})

" Show only Perl sub defns...
nmap <silent> <expr>  fszp FS_FoldAroundTarget('^\s*sub\s\+\w\+',{'context':1})

" Show only Perl sub defns and comments...
nmap <silent> <expr>  fsza FS_FoldAroundTarget('^\s*\%(sub\s.*\\|#.*\)',{'context':0, 'folds':'invisible'})

" Show only C #includes...
nmap <silent> <expr>  fszu FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})
