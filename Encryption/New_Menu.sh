#!/bin/bash
 
# clear the screen
tput clear
 
# Move cursor to screen location X,Y (top left is 0,0)
tput cup 2 15
 
# Set a foreground colour using ANSI escape
tput setaf 3
echo ""
cat logo
tput sgr0
 
tput cup 15 17
# Set reverse video mode
tput rev

echo "M A I N - M E N U"
tput sgr0
 
tput cup 17 15
echo "1. RSA Algoritm"
 
tput cup 18 15
echo "2. DES Algoritm Encrypt"
 
tput cup 19 15
echo "3. DES Algoritm Decrypt"
 
tput cup 20 15
echo "4. DES textFile"
 
tput cup 21 15
echo "5. sed (Linux Command)"

tput cup 22 15
echo "6. Kuku"

tput cup 23 15
echo "7. Quit"

# Set bold mode
tput bold
tput cup 25 15
read -p "Enter your choice [1-7] " choice
 
tput clear
tput sgr0
tput rc

 while true; do
        :
    done

