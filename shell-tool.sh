#!/bin/bash
#################################################################
# Program: Shell tool						#
#################################################################
# Version: 0.1
# Date: 01/12/2012
# Author:  Sébastient THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
#  TODO
#  install_cool_bash : trouver une astuce pour que ca ne soit pas ecraser par le .bashrc des utilisateurs
#
#################################################################

source ./util.lib.sh

#############################################################
# Installation des couleurs dans bash						#	
# todo : tester l'existance#  du fichier				    #
# de la fonction avant insertion							#
#############################################################
function install_cool_bash()  {
	if [ ! -f ./bash_color.txt ]
	then
	  print_warning "bash_color.txt is missing"
	  return 0;
	fi	
	result=$(cat /etc/bash.bashrc|grep "Set colorful PS1 only on colorful terminals" |wc -l) 2> /dev/null
	#test de l'existance de la fonction dans le bash.bashrc
	if [ $result -eq 0 ]
	then
	  print_info "Installing bash coloration"
	  cat ./bash_color.txt >> /etc/bash.bashrc
    else
	   print_info "bash coloration already installed" 
	fi 
	pause;
}

######################################
# Start Of Programme	     		 #	
######################################


check_sanity;
while : # Loop forever
do
clear
printf "\e[01;31mInstall Tool\e[00m\n";	
cat << !
 
R U N M E N U
 
1. Install Cool bash
q. Quit
 
!
echo -n " Your choice? : "
read choice
 
case $choice in
1) install_cool_bash ;;
q) exit ;;
*) print_warn "$choice n'est pas un choix valide"; sleep 2 ;;
esac
done