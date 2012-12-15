#!/bin/bash

url="$1"

url=${url#*file=}
line=${url##*line=}
file=${url%%&line*}
file=${file//\%2F/\/}

# Netbeans
#netbeans "$file:$line"
# PhpStorm
#phpstorm --line $line "$file"
# Kate
#kate --line $line "$file"
# Vim
vim "$file" +$line
# Gedit
#gedit +$line "$file"
# Komodo
#komodo "$file#$line"
