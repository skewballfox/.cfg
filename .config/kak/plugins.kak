#for language server features
source "/usr/share/kak-lsp/rc/lsp.kak"
#eval %sh{kak-lsp --kakoune -s $kak_session}
evaluate-commands %sh{
    cork init
    #kak-lsp --kakoune -s $kak_session
}

# uncomment to enable debugging
#eval %sh{echo ${kak_opt_lsp_cmd} >> /tmp/kak-lsp.log}

#maps <c-n> to next placeholder if there is one, otherwise executes c-n as normal
def -hidden insert-c-n %{
    try %{
        lsp-snippets-select-next-placeholders
        exec '<a-;>d'
    } catch %{
        exec -with-hooks '<c-n>'
    }
}

map global insert <c-n> "<a-;>: insert-c-n<ret>"

set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
set global lsp_diagnostic_line_error_sign '!'
set global lsp_diagnostic_line_warning_sign '?'
define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }

hook global WinSetOption filetype=(c|cpp|rust|python) %{
    echo -debug "Enabling LSP for filtetype %opt{filetype}"
    lsp-enable-window
    set-option window lsp_auto_highlight_references true
    set-option window lsp_hover_anchor false
    lsp-auto-hover-enable
    set-face window DiagnosticError default+u
    set-face window DiagnosticWarning default+u
}
hook global KakEnd .* lsp-exit      


# automatically install plug.kak if not available
evaluate-commands %sh{
        plugins="$HOME/.config/kak/plugins"
        mkdir -p $plugins
        [ ! -e "$plugins/plug.kak" ] && \
            git clone -q https://github.com/andreyorst/plug.kak "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}


evaluate-commands %sh{

    if [ ! -x "$(command -v kcr)" ]; then
        temp=`mktemp`
        wget  "https://github.com/alexherbo2/kakoune.cr/releases/download/nightly/kakoune.cr-nightly-x86_64-unknown-linux-musl.zip" -O $temp &&\
        unzip -d $HOME/.local/ $temp &&\
        date -u +"%Y-%m-%dT%H:%M:%SZ" >$HOME/.config/kak/.kcr-install-date &&\
        rm $temp  
    fi
    kcr init kakoune
}

# https://github.com/alexherbo2/auto-pairs.kak
cork autopairs "https://github.com/alexherbo2/auto-pairs.kak"  %{
    hook global WinSetOption filetype=markdown %{
        set-option -add buffer auto_pairs_surround $$$ $$$ $ $ _ _ * *
    }
}

cork surround "alexherbo2/surround.kak"


# https://github.com/andreyorst/kaktree
cork kaktree "https://github.com/andreyorst/kaktree" %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}

# https://github.com/occivink/kakoune-gdb
cork kakoune-gdb "https://github.com/occivink/kakoune-gdb" %{
    declare-user-mode gdb
    map global user d ":enter-user-mode -lock gdb<ret>" -docstring "gdb"
    map global gdb n ":gdb-next<ret>" -docstring "step over (next)"
    map global gdb s ":gdb-step<ret>" -docstring "step in (step)"
    map global gdb f ":gdb-print<ret>" -docstring "step out (finish)"
    map global gdb r ":gdb-start<ret>" -docstring "start"
    map global gdb R ":gdb-run<ret>" -docstring "run"
    map global gdb c ":gdb-continue<ret>" -docstring "continue"
    map global gdb g ":gdb-jump<ret>" -docstring "jump"
    map global gdb G ":gdb-toggle-autojump<ret>" -docstring "toggle autojump"
    map global gdb t ":gdb-toggle-breakpoint<ret>" -docstring "toggle breakpoint"
    map global gdb T ":gdb-backtrace<ret>" -docstring "backtrace"
    map global gdb p ":gdb-print<ret>" -docstring "print"
    map global gdb Q ":gdb-session-new<ret>" -docstring "new"
    map global gdb q ":gdb-session-stop<ret>" -docstring "stop"
}

cork pmanage.kak "https://github.com/andreyorst/pmanage.kak"

cork smarttab.kak "https://github.com/andreyorst/smarttab.kak"

#for clipboard integration
# https://github.com/lePerdu/kakboard
cork kakboard "https://github.com/lePerdu/kakboard" %{
        hook global WinCreate .* %{ kakboard-enable }
}




#JAVA 15 SUPPORT!
cork java-kak "KJ_DUNCAN/kakoune-java.kak" domain "bitbucket.org"

# TODO: add more stuff from 
# https://git.sr.ht/~raiguard/dotfiles/tree/master/item/.config/kak/kakrc

