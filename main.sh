#!/bin/bash
title=""
prompt="Pick an option:"
options=("1. Execute and configure ansible directly in my computer" "2. Create an amazon EC2 instance and configure ansible within")

echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do
  
    case "$REPLY" in
    
    1 ) echo "You picked $opt"
    2 ) echo "You picked $opt"
    
    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done
