" Vim script
" Maintainer: Peter Odding <peter@peterodding.com>
" Last Change: June 15, 2010
" URL: http://peterodding.com/code/vim/publish

function! publish#resolve_files(directory, pathnames) " {{{1
  " Create a dictionary that maps the fully resolved pathnames of the files to
  " be published to the absolute pathnames provided by the user. This enables
  " the script to gracefully handle symbolic links which I use a lot :-)
  let resolved_files = {}
  for pathname in a:pathnames
    let pathname = xolox#path#merge(a:directory, pathname)
    let absolute = fnamemodify(pathname, ':p')
    let resolved_files[resolve(absolute)] = absolute
  endfor
  return resolved_files
endfunction

function! publish#find_tags(files_to_publish) " {{{1
  " Given a dictionary like the one created above, this function will filter
  " the results of taglist() to remove irrelevant entries. In the process tag
  " search ex-commands are converted into line numbers.
  let num_duplicates = 0
  let tags_to_publish = {}
  let s:cached_contents = {}
  for entry in taglist('.')
    let pathname = xolox#path#absolute(entry.filename)
    if has_key(a:files_to_publish, pathname) && s:pattern_to_lnum(entry, pathname)
      if !has_key(tags_to_publish, entry.name)
        let tags_to_publish[entry.name] = entry
      else
        let num_duplicates += 1
        let other = tags_to_publish[entry.name]
        if entry.filename == other.filename && entry.lnum < other.lnum
          let tags_to_publish[entry.name] = entry
        endif
        if num_duplicates <= 3
          let tag_name = string(entry.name)
          let this_path = string(entry.filename)
          let other_path = string(other.filename)
          let msg = "publish.vim: Ignoring duplicate tag %s! (duplicate is in %s, first was in %s)"
          call xolox#warning(msg, tag_name, this_path, other_path)
        endif
      endif
    endif
  endfor
  if num_duplicates > 3
    let more = num_duplicates - 3
    let msg = "publish.vim: Ignored %s more duplicate tag%s!"
    call xolox#warning(msg, more, more == 1 ? '' : 's')
  endif
  unlet s:cached_contents
  return tags_to_publish
endfunction

function! s:pattern_to_lnum(entry, pathname) " {{{2
  " Tag file entries can refer to source file locations with line numbers and
  " search patterns. Since search patterns are more flexible I use those, but
  " the plug-in needs absolute line numbers, so this function converts search
  " patterns into line numbers.
  if a:entry.cmd =~ '^\d\+$'
    let a:entry.lnum = a:entry.cmd + 0
    return 1
  else
    if !has_key(s:cached_contents, a:pathname)
      let contents = readfile(a:pathname)
      let s:cached_contents[a:pathname] = contents
    else
     let contents = s:cached_contents[a:pathname]
    endif
    let pattern = substitute(a:entry.cmd, '^/\(.*\)/$', '\1', '')
    let pattern = substitute(pattern, '\~', '\\~', 'g')
    try
      let index = match(contents, pattern)
    catch
      throw "Failed pattern: " . string(pattern)
    endtry
    if index >= 0
      let a:entry.lnum = index + 1
      return 1
    endif
  endif
endfunction

function! publish#create_subst_cmd(tags_to_publish) " {{{1
  " Generate a :substitute command that, when executed, replaces tags with
  " hyperlinks using a callback. This is complicated somewhat by the fact that
  " tag names won't always appear literally in the output of 2html.vim, for
  " example the names of Vim autoload functions appear as:
  " 
  "   foo#bar#<span class=Normal>baz</span>
  " 
  let patterns = []
  for name in keys(a:tags_to_publish)
    let tokens = []
    for token in split(name, '\W\@=\|\W\@<=')
      let escaped = xolox#escape#pattern(token)
      call add(tokens, s:ignore_html(token))
    endfor
    let entry = a:tags_to_publish[name]
    if g:publish_viml_sl_hack && get(entry, 'language') == 'Vim'
      let subpattern = '\s\(s:\|<[Ss][Ii][Dd]>\)' . name . '\s*('
      if get(entry, 'cmd') =~ subpattern
        if !exists('s:viml_sl_prefix')
          let s:viml_sl_prefix = s:nasty()
        endif
        call insert(tokens, s:viml_sl_prefix)
      endif
    endif
    call add(patterns, join(tokens, ''))
  endfor
  let tag_names_pattern = escape(join(patterns, '\|'), '/')
  " Gotcha: Use \w\@<! and \w\@! here instead of \< and \> which won't work.
  return '%s/[A-Za-z0-9_]\@<!\%(' . tag_names_pattern . '\)[A-Za-z0-9_]\@!/\=s:ConvertTagToLink(submatch(0))/eg'
endfunction

function! s:ignore_html(s)
  return printf('\%%(<[^/][^>]*>%s</[^>]\+>\|%s\)', a:s, a:s)
endfunction

function! s:nasty()
  " return '\%(s:\|&lt;[Ss][Ii][Dd]&gt;\)'
  let short = s:ignore_html('s') . s:ignore_html(':')
  let long = s:ignore_html('&lt;') . s:ignore_html('[Ss][Ii][Dd]') . s:ignore_html('&gt;')
  return '\%(' . short . '\|' . long . '\)'
endfunction

function! publish#rsync_check(target) " {{{1
  let matches = matchlist(a:target, '^sftp://\([^/]\+\)\(.*\)$')
  if len(matches) >= 3
    let host = matches[1]
    let path = substitute(matches[2], '^/', '', '')
    call system('rsync --version')
    if !v:shell_error
      call system('ssh ' . host . ' rsync --version')
      if !v:shell_error
        return host . ':' . path
      endif
    endif
  endif
  return ''
endfunction

function! publish#run_rsync(target, tempdir) " {{{1
  let target = fnameescape(a:target . '/')
  let tempdir = fnameescape(a:tempdir . '/')
  call xolox#message("Publishing files to %s using rsync..", a:target)
  execute '!rsync -vr' tempdir target
  if v:shell_error
    throw "publish.vim: Failed to run rsync!"
  endif
endfunction

function! publish#create_dirs(target_path) " {{{1
  " If the directory where the files are published resides on the local file
  " system then try to automatically create any missing directories because
  " creating those directories by hand quickly gets tiresome.
  if a:target_path !~ '://'
    let current_directory = fnamemodify(a:target_path, ':h')
    if !isdirectory(current_directory)
      silent! call mkdir(current_directory, 'p')
      if !isdirectory(current_directory)
        let msg = "Failed to create directory %s! What now?"
        if confirm(printf(msg, string(current_directory)), "&Abort\n&Ignore") == 1
          let msg = "publish.vim: Failed to create %s, aborting .."
          call xolox#warning(msg, string(current_directory))
          return 0
        else
          let msg = "publish.vim: Failed to create %s, ignoring .."
          call xolox#warning(msg, string(current_directory))
          continue
        endif
      endif
    endif
  endif
  return 1
endfunction

function! publish#prep_env(enable) " {{{1

  " Change the environment before publishing and restore afterwards.

  " Avoid E325 when publishing files that are currently being edited in Vim.
  augroup PluginPublish
    autocmd!
    if a:enable
      autocmd SwapExists * let v:swapchoice = 'e'
    endif
  augroup END

  " Avoid triggering automatic commands intended to update `Last changed'
  " headers and such by executing :write commands, because the source files
  " aren't actually modified but only copied. I can't use :noautocmd :write
  " for this because that would disable remote publishing through the netrw
  " plug-in! Therefor I've resorted to the following:
  if a:enable
    let s:ei_save = &eventignore
    set eventignore=BufWritePre
  else
    let &eventignore = s:ei_save
  endif

  " Avoid E488 which happens when you publish using netrw, overwriting
  " previously published files that contain modelines.
  if a:enable
    let s:mls_save = &modelines
    set modelines=0
  else
    let &modelines = s:mls_save
  endif

  " Instruct the 2html script to add line numbers that we'll transform into
  " anchors which are used as the targets of hyperlinks created from tags.
  " Also instruct the 2html script to use CSS which we will modify to improve
  " the appearance of hyperlinks (so they inherit the highlighting color).
  if a:enable
    let s:hnl_save = exists('g:html_number_lines') ? g:html_number_lines : 0
    let s:huc_save = exists('g:html_use_css') ? g:html_use_css : 0
    let g:html_number_lines =  1
    let g:html_use_css = 1
  else
    let g:html_number_lines =  s:hnl_save
    let g:html_use_css =  s:huc_save
  endif

endfunction

function! publish#customize_html(page_title) " {{{1

  " Change document title to relative pathname.
  silent keepjumps %s@<title>\zs.*\ze</title>@\=a:page_title@

  " Insert CSS to remove the default colors and underline from hyper links
  " and to remove any padding between the browser chrome and page content.
  let custom_css = "\nhtml, body, pre { margin: 0; padding: 0; }"
  let custom_css .= "\na:link, a:visited { color: inherit; text-decoration: none; }"
  let custom_css .= "\npre:hover a:link, pre:hover a:visited { text-decoration: underline; }"
  let custom_css .= "\na:link span, a:visited span { text-decoration: inherit; }"
  let custom_css .= "\n.lnr a:link, .lnr a:visited { text-decoration: none !important; }"
  silent keepjumps %s@\ze\_s\+-->\_s\+</style>@\= "\n" . custom_css@

  " Add link anchors to line numbering.
  silent keepjumps %s@<span class="lnr">\zs\s*\(\d\+\)\s*\ze</span>@<a name="l\1" href="#l\1">\0</a>@g

endfunction

" vim: ts=2 sw=2 et
