
source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/plug.kak" noload
plug "alexherbo2/auto-pairs.kak" config %{
    hook global WinSetOption filetype=markdown %{
        set-option -add buffer auto_pairs_surround $$$ $$$ $ $ _ _ * *
    }
}
plug "alexherbo2/surround.kak"

plug "aparkerdavid/kakoune-rainbow"

plug "andreyorst/kaktree" config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}

plug "occivink/kakoune-gdb"


plug "lePerdu/kakboard" %{
        hook global WinCreate .* %{ kakboard-enable }
}

plug "ul/kak-lsp" do %{
    cargo build --release --locked
    cargo install --force --path .
} config %{
      # uncomment to enable debugging
      # eval %sh{echo ${kak_opt_lsp_cmd} >> /tmp/kak-lsp.log}
      # set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"


      set global lsp_diagnostic_line_error_sign '!'
      set global lsp_diagnostic_line_warning_sign '?'
      define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
      define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
      define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

      define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
      hook global WinSetOption filetype=(c|cpp|rust|java|python) %{
          echo -debug "Enabling LSP for filtetype %opt{filetype}"
          lsp-enable-window
          set-option window lsp_auto_highlight_references true
          set-option window lsp_hover_anchor false
          lsp-auto-hover-enable
          set-face window DiagnosticError default+u
          set-face window DiagnosticWarning default+u
      }

      hook global WinSetOption filetype=rust %{
          set-option window lsp_server_configuration rust.clippy_preference="on"
          hook window BufWritePre .* %{
              evaluate-commands %sh{
                  test -f rustfmt.toml && printf lsp-formatting-sync
              }
          }
      }
      #for python language server
     
      hook global WinSetOption filetype=python %{
      set-option window lsp_server_configuration pyls.configurationSources=["flake8"]
      set-option window lsp_server_configuration pyls.plugins.pyls_mypy.enabled=true
      set-option window lsp_server_configuration pyls.plugins.pyls_mypy.live_mode=false
      hook window BufWritePre .* lsp-formatting-sync
      }
      hook global KakEnd .* lsp-exit
}

#plug 'delapouite/kakoune-i3' %{
#      # Suggested mapping
#       map global user 3 ': enter-user-mode i3<ret>' -docstring 'i3…'
#

#plug "occivink/kakoune-snippets" config %{
#  set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
#  #other snippet optons
#  }

#plug "skewballfox/kakoune-snippet-collection"
