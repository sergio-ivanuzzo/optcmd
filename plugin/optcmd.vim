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

    call s:ProcessCommand(choice-1, g:optcmd#commands)

endfunction

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
    let commands = a:commands
    let choice   = a:choice
    let cmd      = commands[choice]
    let c        = cmd['command']
    let p        = cmd['prefix']

    if p == "console"
        :! c
    elseif p == "function"
        :call c
    elseif p == "command"
        : c
    endif

endfunction
