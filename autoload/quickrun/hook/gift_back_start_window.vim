scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:hook = {
\	"name" : "gift_back_start_window",
\	"kind" : "hook",
\	"config" : {
\		"enable" : 0,
\	}
\}

function! s:hook.on_normalized(session, context)
	let self.window = gift#tabpagewinnr()
endfunction

function! s:hook.on_finish(session, context)
	call gift#jump_window(self.window)
endfunction


function! quickrun#hook#gift_back_start_window#new()
	return deepcopy(s:hook)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
