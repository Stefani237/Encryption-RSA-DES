#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
cat logo
options=("RSA Algoritm" "DES Algoritm Encrypt" "DES Algoritm Decrypt" "DES textFile" "sed (Linux Command)" "Kuku" "Quit") 

select opt in "${options[@]}"
do
    case $opt in
        "RSA Algoritm")
            echo "you chose RSA"
            perl RSAAlgoritm.pl
            ;;
        "DES Algoritm Encrypt")
            echo "you chose DES Algoritm Encrypt"
            perl des.pl e textFile kerenlaor
            ;;
        "DES Algoritm Decrypt")
            echo "you chose DES Algoritm Decrypt"
            perl des.pl d textFile kerenlaor
            ;;
        "DES textFile")
            echo "you chose DES textFile with 'kerenlaor' key"
            echo ""
            echo "##################################"
            cat textFile
            echo "##################################"
            echo ""
            ;;
        "sed (Linux Command)")
            echo "you chose sed. This is example:"
            echo "# perl sed.pl s/abc/nights/g old new"
            perl sed.pl s/abc/nights/g old new
            echo "####################### cat old############################"
            cat old
            echo "####################### cat new############################"
            cat new
            ;;
        "Kuku")
            echo "Hi Alex!"
            w3m Alex.jpg
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
