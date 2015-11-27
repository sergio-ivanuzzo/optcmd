" File:        optcmd.vim
" Description: vim global plugin that provides binding of multiple commands on one key. 
"              How command will be processing depends on command prefix.
" Author:      Sergio Ivanuzzo <sergio.ivanuzzo at gmail dot com>
" Version:     1.0.0
" License:     GNU GPL

if exists('g:loaded_optcmd')
    finish
endif

let g:loaded_optcmd = 1

function optcmd#ChooseCommand(message, commands)
    let commands = s:ConvertCommands(a:commands)
    let choice   = confirm(a:message, commands)

    call s:ProcessCommand(choice-1, a:commands)

endfunction

" converting commands list into string for passing into confirm() as choices
function! s:ConvertCommands(commands)
    let result   = ""

    for cmd in a:commands
        if !empty(cmd['command']) && !empty(cmd['prefix'])
            if !empty(cmd['index'])
                let cmd_index = cmd['index']
            else
                let cmd_index = ""
            endif
            
            let item = "&" . cmd_index . "[" . cmd['prefix'] . "]" . cmd['command'] . "\n"
            let result .= item
        endif
    endfor

    return result[:-1]

endfunction

function! s:ProcessCommand(choice, commands)
    let cmd      = a:commands[a:choice]
    let c        = cmd['command']
    let p        = cmd['prefix']

    if p == "console"
        " run command from shell
        execute '!' . c
    elseif p == "function"
        " run command via call
        execute 'call' . c
    elseif p == "command"
        " run command as native vim function
        execute '' . c
    endif

endfunction
