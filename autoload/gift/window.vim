scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:uniq_counter = 0
function! gift#window#make_uniq_nr()
	let s:uniq_counter += 1
	return s:uniq_counter
endfunction


function! gift#window#numbering(...)
	let winnr = get(a:, 1, winnr())
	let tabnr = get(a:, 2, tabpagenr())
	let uniq_nr = gift#window#make_uniq_nr()
	call settabwinvar(tabnr, winnr, "gift_uniq_winnr", uniq_nr)
	return uniq_nr
endfunction


function! gift#window#uniq_nr(...)
	let winnr = get(a:, 1, winnr())
	let tabnr = get(a:, 2, tabpagenr())
	let uniq_nr = gettabwinvar(tabnr, winnr, "gift_uniq_winnr", -1)
	if uniq_nr == -1
		let uniq_nr = gift#window#numbering(winnr, tabnr)
	endif
	return uniq_nr
endfunction


function! gift#window#exists(nr)
	let [tabnr, winnr] = gift#window#tabpagewinnr(a:nr)
	return tabnr != 0 && winnr != 0
endfunction


function! gift#window#tabpagewinnr(nr)
	if a:nr == 0
		return gift#window#tabpagewinnr(gift#window#uniq_nr())
	endif
	let tabwinnrs = gift#tabpagewinnr_list()
	for [tabnr, winnr] in tabwinnrs
		if gift#uniq_winnr(winnr, tabnr) == a:nr
			return [tabnr, winnr]
		endif
	endfor
	return [0, 0]
endfunction


function! gift#window#getvar(nr, varname, ...)
	let def = get(a:, 1, "")
	let [tabnr, winnr] = gift#window#tabpagewinnr(a:nr)
	return gettabwinvar(tabnr, winnr, a:varname, def)
endfunction


function! gift#window#setvar(nr, varname, val)
	let [tabnr, winnr] = gift#window#tabpagewinnr(a:nr)
	if tabnr == 0 || winnr == 0
		return
	endif
	return settabwinvar(tabnr, winnr, a:varname, a:val)
endfunction


function! gift#window#bufnr(nr)
	let [tabnr, winnr] = gift#window#tabpagewinnr(a:nr)
	return winnr >= 1 ? get(tabpagebuflist(tabnr), winnr-1, -1) : -1
endfunction



function! gift#window#set_current(nr)
	let [tabnr, winnr] = gift#window#tabpagewinnr(a:nr)
	if tabnr == 0 || winnr == 0
		return -1
	endif

	execute "tabnext" tabnr
	execute winnr . "wincmd w"
endfunction


function! gift#window#close(nr)
	let current = gift#uniq_winnr()
	let result = gift#window#set_current(a:nr)
	if result == -1
		return -1
	endif
	close
	call gift#window#set_current(current)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
