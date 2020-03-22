function jtc
    set file (basename $argv .java)
    if not test -d .output
        mkdir .output
    end
    if command -v termux-setup-storage
        ecj -s .output/ $file.java; and \
        dx --dex --ouput=.output/$file.dex .output/$file.class; and \
        dalvikim -cp .output/$file.dex .output/$file
    else
        javac -implicit:class -d .output/ $file.java; and \
        java -cp .output $file
    end
end
        
