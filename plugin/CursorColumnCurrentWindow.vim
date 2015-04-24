" CursorColumnCurrentWindow.vim: Only highlight the screen column of the cursor in the currently active window.
" @see also https://github.com/vim-scripts/CursorLineCurrentWindow
"
" DEPENDENCIES:
"
" Copyright: (C) 2015 Kortina
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer: Kortina
"

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_CursorColumnCurrentWindow') || (v:version < 700)
    finish
endif
let g:loaded_CursorColumnCurrentWindow = 1

"- functions -------------------------------------------------------------------

" Note: We use both global and local values of 'cursorcolumn' to store the states,
" though 'cursorcolumn' is window-local and only the &l:cursorcolumn value
" effectively determines the visibility of the highlighting. This makes for a
" better value inheritance when splitting windows than a separate window-local
" variable would.

function! s:CursorColumnOnEnter()
    if s:cursorcolumn
	if &g:cursorcolumn || exists('w:persistent_cursorcolumn') && w:persistent_cursorcolumn
	    setlocal cursorcolumn
	else
	    setglobal cursorcolumn
	endif
    else
	setlocal nocursorcolumn
    endif
endfunction
function! s:CursorColumnOnLeave()
    if s:cursorcolumn
	if &l:cursorcolumn
	    if ! &g:cursorcolumn
		" user did :setlocal cursorcolumn
		set cursorcolumn
	    endif
	else
	    if &g:cursorcolumn
		" user did :setlocal nocursorcolumn
		set nocursorcolumn
	    else
		" user did :set nocursorcolumn
		let s:cursorcolumn = 0
	    endif
	endif

	if exists('w:persistent_cursorcolumn') && w:persistent_cursorcolumn
	    setglobal nocursorcolumn
	    setlocal cursorcolumn
	else
	    setlocal nocursorcolumn
	endif
    else
	if &g:cursorcolumn && &l:cursorcolumn
	    " user did :set cursorcolumn
	    let s:cursorcolumn = 1
	endif
    endif
endfunction


"- autocmds --------------------------------------------------------------------

let s:cursorcolumn = &g:cursorcolumn
augroup CursorColumn
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call <SID>CursorColumnOnEnter()
    autocmd WinLeave                      * call <SID>CursorColumnOnLeave()
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
