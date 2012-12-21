#!/bin/bash
#################################################################
# Program: Security tool						#
#################################################################
# Version: 0.1
# Date: 30/11/2012
# Author:  Sébastien THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
# Todo :
#
# Note :
#find / \
# \( -perm -4000 -fprintf /root/suid.txt %#m %u %p\n \) , \
# \( -size +100M -fprintf /root/grand.txt %-10s %p\n \)
#####################################################################
source ./util.lib.sh
#############################################################
# Liste les processus qui fonctionne 						#	
#############################################################
function list_progs(){
	ps auxw|less
}
#############################################################################
# Liste les utilisateurs connecter et les fonctions qu'ils executent		#	
#############################################################################
function who_is_logged(){
	w
    pause
}
#############################################################
# Run nmap en local pour voir les port ouvert				#
# possible d'installer nmap s'il l'es pas par defaut        #	
#############################################################
function run_nmap_local(){
 if check nmap &> /dev/null  # Suppress output.
 then
    whiptail --title "Nmap manquant" --yesno  "Voulez vous installer Nmap" 10 30
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	   install_nmap
	   clear
       nmap localhost
	   pause
	fi
	
 else
	nmap localhost
	pause
 fi

}
#############################################################
# Run logwath 												#
# possible d'installer logwath s'il l'es pas par defaut     #	
#############################################################
function run_logwatch(){
 if check logwatch &> /dev/null  # Suppress output.
 then
    whiptail --title "Logwatch manquant" --yesno  "Voulez vous installer Logwatch" 10 30
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	   install_logwatch
	   clear
       /usr/sbin/logwatch --filename /tmp/logwatch_out.txt
       pager /tmp/logwatch_out.txt
       clear
       rm /tmp/logwatch_out.txt
	fi
	
 else
    /usr/sbin/logwatch --filename /tmp/logwatch_out.txt
    pager /tmp/logwatch_out.txt
    clear
    rm /tmp/logwatch_out.txt
 fi

}

