function md2pdf
    #TODO figure out a way to check and scrub full path as to now make a mess when
    #outputting to downloads directory
    set file (basename $argv)
    pandoc --from markdown --to markdown --wrap=preserve --reference-links --output $XDG_DOWNLOAD_DIR/uploads/$file $argv
end