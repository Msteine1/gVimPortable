" Vim indent file
" Language:	    SAS
" Maintainer:       Zhenhuan Hu <zhu@mcw.edu>
" Latest Revision:  2012-05-09

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSASIndent() indentkeys+==data,=proc,=run;,=quit;,=end;,=endsas,=enddata,=select,=%macro,=%mend

if exists("*GetSASIndent")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Regex that defines the start of a section
let s:section_begin_regex = '^\s*\<\(data\|proc\)\>'

" Regex that defines the start of a block
let s:block_begin_regex = '\(\<do\>.*\<to\>\|\<do;\|\<select (\|\<select;\)'

" Regex that defines the start of a macro
let s:macro_begin_regex = '^\s*%macro\>'

" Regex that defines the end of a section
let s:section_end_regex = '^\s*\(run\|quit\|enddata\);'

" Regex that defines the end of a block
let s:block_end_regex = '^\s*end;'

" Regex that defines the end of a macro
let s:macro_end_regex = '^\s*%mend\>'

" Regex that defines the end of the program
let s:prog_end_regex = '^\s*\<endsas\>'

" Find the line number of previous keyword defined by the regex
function s:PrevRegex(lnum, regex)
	let lnum = prevnonblank(a:lnum - 1)
	while lnum > 0
		let line = getline(lnum)
		if line =~ a:regex
			break
		else
			let lnum = prevnonblank(lnum - 1)
		endif
	endwhile
	return lnum
endfunction

" Main function
function GetSASIndent()
	let lnum = prevnonblank(v:lnum - 1)
	let ind = indent(lnum)
	let pline = getline(lnum)
	let cline = getline(v:lnum)

	" First non-blank line of the program
	if lnum == 0
		return 0
	endif

	" Previous non-blank line is the start of a section/macro/block
	if pline =~ s:section_begin_regex
	\ || pline =~ s:macro_begin_regex
	\ || pline =~ s:block_begin_regex
		let ind = ind + &sts
	endif

	" Current line is the start/end of a section
	if cline =~ s:section_begin_regex
	\ || cline =~ s:section_end_regex
		let prev_start_lnum = s:PrevRegex(v:lnum, s:section_begin_regex)
		let prev_end_lnum = max([s:PrevRegex(v:lnum, s:section_end_regex), s:PrevRegex(v:lnum, s:macro_end_regex), s:PrevRegex(v:lnum, s:prog_end_regex), s:PrevRegex(v:lnum, s:macro_begin_regex)])
		if prev_end_lnum < prev_start_lnum
			return ind - &sts
		endif
	endif

	" Current line is the end of a block
	if cline =~ s:block_end_regex
		return ind - &sts
	endif

	" Current line is the end of a macro
	if cline =~ s:macro_end_regex
		let prev_macro_lnum = s:PrevRegex(v:lnum, s:macro_begin_regex)
		let ind = indent(prev_macro_lnum)
		return ind
	endif

	" Current line is the end of the program
	if cline =~ s:prog_end_regex
		return 0
	endif

	return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
