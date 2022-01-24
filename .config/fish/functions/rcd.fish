function rcd -w 'ranger' -d 'Automatically change the directory in fish after closing ranger'
    set -l tempfile (mktemp -t tmp.XXXXXX)
    ranger --choosedir=$tempfile $argv
    if [ -f $tempfile ]
        #add path to zoxide if it exist
        command -q zoxide; and zoxide add (cat $tempfile)
        cd (cat $tempfile)
    end
    rm -f $tempfile
end
