#!/bin/bash

args=()
text=$(curl -s https://raw.githubusercontent.com/powerlanguage/word-lists/master/word-list-raw.txt)
while (( $# > 0 ))
do
    case $1 in
        -n|--none)
            NONE=$2
            shift 2
        ;;
        -i|--in)
            IN=$2
            shift 2
        ;;
        *)
            args+=($1)
            shift
        ;;
    esac
done

text=$(echo "$text"|awk -F " " "{if(length(\$0)==${args[0]}){print \$0}}")

if [[ "$NONE" != "" ]]; then
    args[1]=$(echo "${args[1]}"|sed -e "s/\./[^${NONE}]/g")
fi
text=$(echo "$text"|grep -e "${args[1]}")

if [[ "$IN" != "" ]]; then
    for ((i=0; i<${#IN}; i++))
    do
        if [[ "${IN:i:1}" != "." ]]; then
            text=$(echo "$text"|grep -e ".*${IN:i:1}.*"|grep -v "^.\{$i\}${IN:i:1}.\{$((args[0]-i-1))\}\$")
        fi
    done
fi

echo $text
