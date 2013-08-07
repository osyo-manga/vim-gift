scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim



let s:uniq_counter = 0
function! gift#tabpage#make_uniq_nr()
	let s:uniq_counter += 1
	return s:uniq_counter
endfunction


function! gift#tabpage#numbering(...)
	let tabnr = get(a:, 1, tabpagenr())
	let uniq_nr = gift#tabpage#make_uniq_nr()
	call settabvar(tabnr, "gift_tabpage_uniq_nr", uniq_nr)
	return uniq_nr
endfunction


function! gift#tabpage#uniq_nr(...)
	let tabnr = get(a:, 1, tabpagenr())
	let uniq_nr = gettabvar(tabnr, "gift_uniq_tabpagenr", -1)
	if uniq_nr == -1
		let uniq_nr = gift#tabpage#numbering(tabnr)
	endif
	return uniq_nr
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
