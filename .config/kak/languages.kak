##################### Language support #########################
################################################################


hook global WinSetOption filetype=plain %{
        modeline-parse
}
#Rust
hook global WinSetOption filetype=rust %{
    require-module auto-pairs
    auto-pairs-enable
    set-option window lsp_server_configuration rust.clippy_preference="on"
    set window formatcmd 'rustfmt'
    hook window BufWritePre .* %{
        evaluate-commands %sh{
            test -f rustfmt.toml && printf lsp-formatting-sync
        }
    }
}


#markdown
hook global WinSetOption filetype=markdown %{
    add-highlighter global/wrap wrap -word
}

#python
hook global WinSetOption filetype=python %{
    set window autowrap_column 80
    require-module auto-pairs
    auto-pairs-enable
    set-option window lsp_server_initialization_options %sh{echo python.interpreter.properties.InterpreterPath=\"$(which python)\"}
    set-option window lsp_server_initialization_options %sh{echo python.interpreter.properties.Version=\"$(python -V | sed 's/.* //')\"}
    set-option window lsp_server_configuration settings.python.analysis.logLevel="Information"
    #settings.python.linting.pylintEnabled=true
    set-option global lsp_server_initialization_options python.interpreter.properties.UseDefaultDatabase=true
    
    set-option window formatcmd 'black -q -'
    hook window BufWritePre .* lsp-formatting-sync
    #hook window BufWritePre .* %{
    #    evaluate-commands %sh{
    #        bandit -r -
    #    }
   # }
}


#C++
hook global WinSetOption filetype=(c|cpp) %{
    auto-pairs-enable
    set-option window formatcmd 'clang-format'
    clang-enable-autocomplete
    clang-enable-diagnostics
    alias window lint clang-parse
    alias window lint-next-error clang-diagnostics-next
}

#Java
#hook global WinSetOption filetype(.java)

## C Cpp Rust Java


#evaluate-commands %sh{
#    for filetype in c cpp rust java; do
#        printf "%s\n" "add-highlighter shared/$filetype/code/functions    regex (\w*?)\b(for|if|while)?(\h+)?(?=\() 1:function
#                       add-highlighter shared/$filetype/code/struct_field regex ((?<!\.\.)(?<=\.)|(?<=->))[a-zA-Z](\w+)?\b(?![>\"\(]) 0:rgb:fb4934,default+b
#                       add-highlighter shared/$filetype/code/method       regex ((?<!\.\.)(?<=\.)|(?<=->))[a-zA-Z](\w+)?(\h+)?(?=\() 0:function
#                       add-highlighter shared/$filetype/code/return       regex \breturn\b 0:rgb:fb4934,default+b"
#    done
#    for filetype in c cpp; do
#        printf "%s\n" "add-highlighter shared/$filetype/code/types_1 regex \b(v|u|vu)\w+(8|16|32|64)(_t)?\b 0:type
#                       add-highlighter shared/$filetype/code/types_2 regex \b(v|u|vu)?(_|__)?(s|u)(8|16|32|64)(_t)?\b 0:type
#                       add-highlighter shared/$filetype/code/types_3 regex \b(v|u|vu)(_|__)?(int|short|char|long)(_t)?\b 0:type
#                       add-highlighter shared/$filetype/code/types_4 regex \b\w+_t\b 0:type"
#    done
#    for filetype in cpp rust; do
#        printf "%s\n" "add-highlighter shared/$filetype/code/  regex [a-zA-Z](\w+)?(\h+)?(?=::) 0:rgb:be8019,default"
#    done
#}
