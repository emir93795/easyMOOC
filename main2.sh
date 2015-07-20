#!/bin/bash

#Available colors (Seen in stackoverflow.com)
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      MAGENTA=$(tput setaf 9)
      ORANGE=$(tput setaf 172)
      GREEN=$(tput setaf 190)
      PURPLE=$(tput setaf 141)
      WHITE=$(tput setaf 256)
    else
      MAGENTA=$(tput setaf 5)
      ORANGE=$(tput setaf 4)
      GREEN=$(tput setaf 2)
      PURPLE=$(tput setaf 1)
      WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    BLUE="\033[1;34m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi


#Function that installs ansible
function ansibleInstallation(){
    if yum list installed ansible >/dev/null 2>&1; then
        echo -e "${NUMBER}Ansible is already installed.\n${NORMAL}"
    else
        sudo rpm -ivh --force http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        sudo yum install -y ansible
        #Check if ansible is correctly installed
        if yum list installed ansible >/dev/null 2>&1; then
            echo -e "${NUMBER}Ansible was correctly installed.\n${NORMAL}"
        else   
            echo -e "${RED_TEXT}Ansible was not correctly installed.\n${NORMAL}"
        fi
    fi
    
    echo -e "${RED_TEXT}Please remember that you need to have your SSH keys configured, \nbefore you proceed with the process.\n${NORMAL}"
    echo -e "${MENU}You can configure your keys using:${NORMAL}"
    echo -e "${NUMBER}    ssh-agent bash${NORMAL}"
    echo -e "${NUMBER}    ssh-add pathTOyourKey/keyName.pem\n${NORMAL}"
    echo -e "${RED_TEXT}(The key must have special permissions (400 or 600), use chmod for that.${NORMAL}"
    
}


while :
do
    clear
    cat<<EOF
$GREEN===================================================================================$RESET
$BOLD Easy MOOC setup menu
$RESET$GREEN-----------------------------------------------------------------------------------$RESET
$BOLD Please enter your choice:
 
  (1)$RESET  Execute and configure ansible directly in my computer (install MOOC here).
  $BOLD(2)$RESET  Create an amazon EC2 instance and configure ansible within.
       $BOLD(Q)$RESETuit
$GREEN-----------------------------------------------------------------------------------$RESET
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  cat<<EOF
$BOLD Reading config....
EOF
		  ansibleInstallation
		  source config.cfg        
		  export AWS_ACCESS_KEY=$AWS_ACCESS_KEY
		  export AWS_SECRET_KEY=$AWS_SECRET_KEY 
		  cp create_ec2_InstanceNOMODIFY.yml create_ec2_Instance.yml
		  sed -i "s/sa-east-1a/$ZONE/g" create_ec2_Instance.yml
		  sed -i "s/ami-8737829a/$AMI_ID/g" create_ec2_Instance.yml
		  sed -i "s/t2.micro/$INSTANCE_TYPE/g" create_ec2_Instance.yml
		  sed -i "s/sa-east-1/$REGION/g" create_ec2_Instance.yml
		  sed -i "s/AmazonKeyValue/$KEY_NAME/g" create_ec2_Instance.yml
		  sed -i "s/vpc-e4921349/$SUBNET_ID/g" create_ec2_Instance.yml
		  
		  sudo cp create_ec2_Instance.yml /etc/ansible/create_ec2_Instance.yml
          sudo cp LAMPMoodlePlaybookNOMODIFY.yml /etc/ansible/LAMPMoodlePlaybook.yml
          sudo cp LAMPMoodleScriptNOMODIFY.sh /etc/ansible/LAMPMoodleScript.sh
		  
		  sleep 10
		  
		  cd /etc/ansible
          sudo rm -r hosts
          sudo sh -c 'echo "127.0.0.1" >> hosts'
          #Creating instance
          ansible-playbook create_ec2_Instance.yml
		  echo 'Working........'
          sleep 5s
          #Installing LAMP environment
          ansible-playbook LAMPMoodlePlaybook.yml 
		  sleep 5s;;
		  
    "2")  echo "you chose choice 2" ;;
    "Q")  exit                      ;;
    "q")  exit                      ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
