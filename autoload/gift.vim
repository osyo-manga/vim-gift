scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:to_fullpath(filename)
	let name = substitute(fnamemodify(a:filename, ":p"), '\', '/', "g")
	if filereadable(name)
		return name
	else
		return a:filename
	endif
endfunction

function! s:flatten(list)
	return eval(join(a:list, "+"))
endfunction



function! gift#bufnr(expr)
	return type(a:expr) == type([])
\		 ? gift#bufnr(gift#uniq_winnr(a:expr[1], a:expr[0]))
\		 : gift#window#bufnr(a:expr)
endfunction


function! gift#openable_bufnr_list()
	return map(gift#tabpagewinnr_list(), "gift#bufnr([v:val[0], v:val[1]])")
endfunction


function! gift#tabpagewinnr(...)
	return a:0 == 0 ? gift#tabpagewinnr(gift#uniq_winnr())
\		 : gift#window#tabpagewinnr(a:1)
endfunction


function! gift#tabpagewinnr_list()
	return s:flatten(map(range(1, tabpagenr("$")), "map(range(1, tabpagewinnr(v:val, '$')), '['.v:val.', v:val]')"))
endfunction



function! gift#uniq_winnr(...)
	return call("gift#window#uniq_nr", a:000)
endfunction


function! gift#uniq_winnr_list(...)
	return map(gift#tabpagewinnr_list(), "gift#uniq_winnr(v:val[1], v:val[0])")
endfunction



function! gift#find(expr)
	let gift_find_result = []
	for [tabnr, winnr] in gift#tabpagewinnr_list()
		let bufnr = gift#bufnr([tabnr, winnr])
		if eval(a:expr)
			call add(gift_find_result, [tabnr, winnr])
		endif
	endfor
	return gift_find_result
endfunction


function! gift#find_by(func)
	return filter(gift#tabpagewinnr_list(), "a:func(gift#bufnr([v:val[0], v:val[1]), v:val[0], v:val[1])")
endfunction


function! gift#set_current_window(expr)
	return type(a:expr) == type([])
\		 ? gift#set_current_window(gift#uniq_winnr(a:expr[1], a:expr[0]))
\		 : gift#window#set_current(a:expr)
endfunction


function! gift#close_window(expr, ...)
	let close_cmd = get(a:, 1, "close")
	return type(a:expr) == type([])
\		 ? gift#close_window(gift#uniq_winnr(a:expr[1], a:expr[0]), close_cmd)
\		 : gift#window#close(a:expr, close_cmd)
endfunction


function! gift#close_window_by(expr, findexpr, ...)
	let close_cmd = get(a:, 1, "close")
	return map(gift#find(a:findexpr), 'gift#close_window(v:val)')
endfunction


function! gift#close_window_by(expr, ...)
	let close_cmd = get(a:, 1, "close")
	return map(gift#find(a:expr), 'gift#close_window(v:val, close_cmd)')
endfunction




function! gift#getwinvar(uniq_winnr, varname, ...)
	let def = get(a:, 1, "")
	return gift#window#getvar(a:uniq_winnr, a:varname, def)
endfunction


function! gift#setwinvar(uniq_winnr, varname, val)
	return gift#window#setvar(a:uniq_winnr, a:varname, a:val)
endfunction





function! gift#uniq_tabpagenr(...)
	return call("gift#tabpage#uniq_nr", a:000)
endfunction




let &cpo = s:save_cpo
unlet s:save_cpo
