#for language server features
source "/usr/share/kak-lsp/rc/lsp.kak"
#eval %sh{kak-lsp --kakoune -s $kak_session}

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
plug "andreyorst/plug.kak" noload

#dependency of auto-pairs and snippets
plug "alexherbo2/prelude.kak"

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
plug "alexherbo2/auto-pairs.kak" config %{
    hook global WinSetOption filetype=markdown %{
        set-option -add buffer auto_pairs_surround $$$ $$$ $ $ _ _ * *
    }
}

plug "alexherbo2/surround.kak"

#dependency of snippets
plug "alexherbo2/phantom.kak"

#plug "aparkerdavid/kakoune-rainbow"

plug "andreyorst/kaktree" config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}

#plug "occivink/kakoune-gdb"

#for clipboard integration
plug "lePerdu/kakboard" %{
        hook global WinCreate .* %{ kakboard-enable }
}




#JAVA 15 SUPPORT!
plug "KJ_DUNCAN/kakoune-java.kak" domain "bitbucket.org"

#plug "alexherbo2/snippets.kak" %{
    # Modules
#    require-module snippets-crystal

    # Options
#    set-option global snippets_scope global
#}
