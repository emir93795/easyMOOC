#!/bin/bash

#Available colors (Seen in stackoverflow.com)
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    
menu(){
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Execute and configure ansible directly in my computer **${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Create an amazon EC2 instance and configure ansible within **${NORMAL}"
    echo -e "${MENU}**${NUMBER}${MENU} (Having an amazon account and a key to acces the instance is strictly necessari!) **${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter OR ${RED_TEXT} press enter to exit. ${NORMAL}"
    read opt
}
menu2(){
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**What kind of MOOC management system are you going to use?**${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Install Moodle **${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Install Canvas **${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Install edX **${NORMAL}"   
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter OR ${RED_TEXT} press enter to exit. ${NORMAL}"
    read opt
}
menu3(){
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**Please, select architecture to use on MOOC:**${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Simple MOOC (All-in-one instance) **${NORMAL}"
    echo -e "${MENU}*                       No separated DB     *${NORMAL}"
    echo -e "${MENU}*                       No Load Balancers   *${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Modular MOOC **${NORMAL}"
    echo -e "${MENU}*                       Separated DB (Amazon RDS)*${NORMAL}"
    echo -e "${MENU}*                       Load Balancer       *${NORMAL}"
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} Custom MOOC **${NORMAL}"   
    echo -e "${MENU}*                                           *${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter OR ${RED_TEXT} press enter to exit. ${NORMAL}"
    read opt
}

function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

#Function that installs ansible
function ansibleInstallation(){
    if yum list installed ansible >/dev/null 2>&1; then
        echo -e "${NUMBER}Ansible is already installed.${NORMAL}"
    else
        sudo rpm -ivh --force http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        sudo yum install -y ansible
    fi
    #Check if ansible is correctly installed
    if yum list installed ansible >/dev/null 2>&1; then
        echo -e "${NUMBER}Ansible was correctly installed.${NORMAL}"
    else   
        echo -e "${RED_TEXT}Ansible was not correctly installed.${NORMAL}"
    fi
}
function menu3IT(){
    menu3
        while [ opt != '' ]
            do
            if [[ $opt = "" ]]; then 
                exit;
            else
                case $opt in
                1) clear;
                option_picked "Let's go!...";
                ;;
                2) clear;
                option_picked "Option 2 Picked";
                ;;
                3) clear;
                option_picked "Option 2 Picked";
                ;;
                x)exit;
                ;;
                \n)exit;
                ;;
                *)clear;
                option_picked "Pick an option from the menu";
                menu2;
                ;;
                esac
            fi 
        done
        ;;
}

 #Funtion that installs moodle using ansible
#Beginning menu
clear
menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "Beginning work...";
        ansibleInstallation
        menu2
        while [ opt != '' ]
            do
            if [[ $opt = "" ]]; then 
                exit;
            else
                case $opt in
                1) clear;
                option_picked "Let's go!...";
                menu3IT
                ;;
                2) clear;
                option_picked "Option 2 Picked";
                ;;
                3) clear;
                option_picked "Option 2 Picked";
                ;;
                x)exit;
                ;;
                \n)exit;
                ;;
                *)clear;
                option_picked "Pick an option from the menu";
                menu2;
                ;;
                esac
            fi 
        done
        ;;

        2) clear;
            option_picked "Option 2 Picked";
            ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        menu;
        ;;
    esac
fi
done
