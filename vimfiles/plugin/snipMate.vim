" ################################ My FixLines " ########################################
"  22
" #######################################################################################
"
" File:          snipMate.vim
" Author:        Michael Sanders
" Version:       0.77
" Last Updated:  March 29, 2009.
" Description:   snipMate.vim implements some of TextMate's snippets features in
"                Vim. A snippet is a piece of often-typed text that you can
"                insert into your document using a trigger word followed by a "<tab>".
"
"                For more help see snipMate.txt; you can do this by using:
"                :helptags ~/.vim/doc
"                :h snipMate.txt

if exists('loaded_snips') || &cp || version < 700
	finish
endif
let loaded_snips = 1
if !exists('snips_author') | let snips_author = 'Me' | endif

"au FileType objc,cpp,cs let &ft = expand('<amatch>').'.c'
au FileType objc,cs let &ft = expand('<amatch>').'.c'
au FileType xhtml let &ft = 'xhtml.html'
au BufRead,BufNewFile *.snippets\= set ft=snippet
au FileType snippet setl noet fdm=indent

let s:snippets = {} | let s:multi_snips = {}

if !exists('snippets_dir')
	let snippets_dir = $HOME.(has('win16') || has('win32') || has('win64') ?
					\ '\vimfiles\snippets\' : '/.vim/snippets/')
	if !isdirectory(snippets_dir)
		let snippets_dir = fnamemodify(finddir('snippets', &rtp), ':p')
	endif
endif

fun! MakeSnip(scope, trigger, content, ...)
	let multisnip = a:0 && a:1 != ''
	let var = multisnip ? 's:multi_snips' : 's:snippets'
	if !has_key({var}, a:scope) | let {var}[a:scope] = {} | endif
	if !has_key({var}[a:scope], a:trigger)
		let {var}[a:scope][a:trigger] = multisnip ? [[a:1, a:content]] : a:content
	elseif multisnip | let {var}[a:scope][a:trigger] += [[a:1, a:content]]
	else
		echom 'Warning in snipMate.vim: Snippet '.a:trigger.' is already defined.'
				\ .' See :h multi_snip for help on snippets with multiple matches.'
	endif
endf

fun! ExtractSnips(dir, ft)
	for path in split(globpath(a:dir, '*'), "\n")
		if isdirectory(path)
			let pathname = fnamemodify(path, ':t')
			for snipFile in split(globpath(path, '*.snippet'), "\n")
				call s:ProcessFile(snipFile, a:ft, pathname)
			endfor
		elseif fnamemodify(path, ':e') == 'snippet'
			call s:ProcessFile(path, a:ft)
		endif
	endfor
endf

" Processes a single-snippet file; optionally add the name of the parent
" directory for a snippet with multiple matches.
fun s:ProcessFile(file, ft, ...)
	let keyword = fnamemodify(a:file, ':t:r')
	if keyword  == '' | return | endif
	try
		let text = join(readfile(a:file), "\n")
	catch /E484/
		echom "Error in snipMate.vim: couldn't read file: ".a:file
	endtry
	return a:0 ? MakeSnip(a:ft, a:1, text, keyword)
			\  : MakeSnip(a:ft, keyword, text)
endf

fun! ExtractSnipsFile(file)
	if !filereadable(a:file) | return | endif
	let text = readfile(a:file)
	let ft = fnamemodify(a:file, ':t:r:s?-.*??')
	let inSnip = 0
	for line in text + ["\n"]
		if inSnip && (line == '' || strpart(line, 0, 1) == "\t")
			let content .= strpart(line, 1)."\n"
			continue
		elseif inSnip
			call MakeSnip(ft, trigger, content[:-2], name)
			let inSnip = 0
		endif

		if stridx(line, 'snippet') == 0
			let inSnip = 1
			let trigger = strpart(line, 8)
			let name = ''
			let space = stridx(trigger, ' ') + 1
			if space " Process multi snip
				let name = strpart(trigger, space)
				let trigger = strpart(trigger, 0, space - 1)
			endif
			let content = ''
		endif
	endfor
endf

fun! ResetSnippets()
	let s:snippets = {} | let s:multi_snips = {} | let g:did_ft = {}
endf

let g:did_ft = {}
fun! GetSnippets(dir, filetype)
	for ft in split(a:filetype, '\.')
		if has_key(g:did_ft, ft) | continue | endif
		for path in split(globpath(a:dir, ft.'/')."\n".
						\ globpath(a:dir, ft.'-*/'), "\n")
			call ExtractSnips(path, ft)
		endfor
		for path in split(globpath(a:dir, ft.'.snippets')."\n".
						\ globpath(a:dir, ft.'-*.snippets'), "\n")
			call ExtractSnipsFile(path)
		endfor
		let g:did_ft[ft] = 1
	endfor
endf

fun! TriggerSnippet()
	if exists('g:SuperTabMappingForward')
		if g:SuperTabMappingForward == "<tab>"
			let SuperTabKey = "\<c-n>"
		elseif g:SuperTabMappingBackward == "<tab>"
			let SuperTabKey = "\<c-p>"
		endif
	endif

	if pumvisible() " Update snippet if completion is used, or deal with supertab
		if exists('SuperTabKey')
			call feedkeys(SuperTabKey) | return ''
		endif
		call feedkeys("\<esc>a", 'n') " Close completion menu
		call feedkeys("\<tab>") | return ''
	endif

	if exists('g:snipPos') | return snipMate#jumpTabStop() | endif

	let word = matchstr(getline('.'), '\S\+\%'.col('.').'c')
	for scope in [bufnr('%')] + split(&ft, '\.') + ['_']
		let trigger = s:GetSnippet(word, scope)
		if exists('g:snippet') | break | endif
	endfor

	" If word is a trigger for a snippet, delete the trigger & expand the snippet.
	if exists('g:snippet')
		if g:snippet == '' " If user cancelled a multi snippet, quit.
			unl g:snippet | return ''
		endif
		let col = col('.') - len(trigger)
		sil exe 's/'.escape(trigger, '.^$/\*[]').'\%#//'
		return snipMate#expandSnip(col)
	elseif exists('SuperTabKey')
		call feedkeys(SuperTabKey)
		return ''
	endif
	return "\<tab>"
endf

" Check if word under cursor is snippet trigger; if it isn't, try checking if
" the text after non-word characters is (e.g. check for "foo" in "bar.foo")
fun s:GetSnippet(word, scope)
	let word = a:word
	wh !exists('g:snippet')
		if exists('s:snippets["'.a:scope.'"]["'.escape(word, '\"').'"]')
			let g:snippet = s:snippets[a:scope][word]
		elseif exists('s:multi_snips["'.a:scope.'"]["'.escape(word, '\"').'"]')
			let g:snippet = s:ChooseSnippet(a:scope, word)
		else
			if match(word, '\W') == -1 | break | endif
			let word = substitute(word, '.\{-}\W', '', '')
		endif
	endw
	return word
endf

fun s:ChooseSnippet(scope, trigger)
	let snippet = []
	let i = 1
	for snip in s:multi_snips[a:scope][a:trigger]
		let snippet += [i.'. '.snip[0]]
		let i += 1
	endfor
	if i == 2 | return s:multi_snips[a:scope][a:trigger][0][1] | endif
	let num = inputlist(snippet) - 1
	return num == -1 ? '' : s:multi_snips[a:scope][a:trigger][num][1]
endf
" vim:noet:sw=4:ts=4:ft=vim
