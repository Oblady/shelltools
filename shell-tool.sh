#!/bin/bash
#################################################################
# Program: Shell tool						#
#################################################################
# Version: 0.1
# Date: 01/12/2012
# Author:  Sébastien THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
#  TODO
#  install_cool_bash : trouver une astuce pour que ca ne soit pas ecraser par le .bashrc des utilisateurs
#
#################################################################

#############################################################
# Installation des couleurs dans bash						#	
# todo : tester l'existance#  du fichier				    #
# de la fonction avant insertion							#
#############################################################
function install_cool_bash()  {
	if [ ! -f ./resources/bash/bash_color.txt ]
	then
	  print_warning "bash_color.txt is missing"
	  return 0;
	fi	
	result=$(cat /etc/bash.bashrc|grep "Set colorful PS1 only on colorful terminals" |wc -l) 2> /dev/null
	#test de l'existance de la fonction dans le bash.bashrc
	if [ $result -eq 0 ]
	then
	  print_info "Installing bash coloration"
	  cat ./resources/bash/bash_color.txt >> /etc/bash.bashrc
    else
	   print_info "bash coloration already installed" 
	fi 
	pause;
}

#############################################################
# Installation  de most un pager avec la coloration			#	
#############################################################
function install_htop()  {
	print_info "installing htop"
    check_and_install htop htop
    pause
}
#############################################################
# Installation  de most un pager avec la coloration			#	
#############################################################
function install_most()  {
	print_info "installing Most"
    check_and_install most most
    print_info "Configuring Most"
    update-alternatives --set pager /usr/bin/most
    pause
}
#############################################################
# Installation ntpdate                       		#	
#############################################################
function install_ntpdate()  {
    print_info "installing ntpdate"
    check_and_install ntpdate ntpdate
    print_info "Configuring ntpdate"
    echo "/usr/sbin/ntpdate -s 0.debian.pool.ntp.org" > /etc/cron.daily/ntpdate 
    pause
}
#############################################################
# Installation de nmap										#	
#############################################################
function install_nmap()  {
	print_info "installing Nmap"
    check_and_install nmap nmap
    pause
}
#############################################################
# Installation de nmap										#	
#############################################################
function install_xsltproc()  {
	print_info "installing xsltproc"
    check_and_install xsltproc xsltproc
    pause
}
#############################################################
# Installation de rkhunter									#	
#############################################################
function install_rkhunter()  {
	print_info "installing rkhunter"
    check_and_install rkhunter rkhunter
    # on debian rkhunter complain about hidden dirs in /dev  
	
	if check_config  "ALLOWHIDDENDIR=/dev/.udev" "/etc/rkhunter.conf"
	then
	    #si KO ajout ligne
		echo "ALLOWHIDDENDIR=/dev/.udev" >>	"/etc/rkhunter.conf";
	fi
	
	if check_config  "ALLOWHIDDENDIR=/dev/.static" "/etc/rkhunter.conf"
	then
	    #si KO ajout ligne
		echo "ALLOWHIDDENDIR=/dev/.static" >>	"/etc/rkhunter.conf";
	fi
	
	if check_config  "ALLOWHIDDENDIR=/dev/.initramfs" "/etc/rkhunter.conf"
	then
	    #si KO ajout ligne
		echo "ALLOWHIDDENDIR=/dev/.initramfs" >>	"/etc/rkhunter.conf";
	fi
	
	pause
}

#############################################################
# Installation de fail2ban										#	
#############################################################
function install_fail2ban()  {
	print_info "installing fail2ban"
    check_and_install fail2ban-server fail2ban
    pause
}
#############################################################
# Installation de chkrootkit										#	
#############################################################
function install_chkrootkit()  {
	print_info "installing chkrootkit"
    check_and_install chkrootkit chkrootkit
    pause
}

#############################################################
# Installation de denyhosts									#	
#############################################################
function install_denyhosts()  {
	print_info "installing denyhosts"
    check_and_install denyhosts denyhosts
    pause
}



#############################################################
# Installation de nmap										#	
#############################################################
function install_logwatch()  {
	print_info "installing Logwatch"
    check_and_install logwatch logwatch
    #ajout des fichier de footer et header html si manquant
    if [ ! -d /usr/share/logwatch/default.conf/html/ ]
	then 
	   mkdir -p /usr/share/logwatch/default.conf/html/
    fi
    if [ ! -f /usr/share/logwatch/default.conf/html/footer.html ]
	then
	   cp ./resources/logwatch/footer.html /usr/share/logwatch/default.conf/html/
    fi
	if [ ! -f /usr/share/logwatch/default.conf/html/header.html ]
	then
	   cp ./resources/logwatch/header.html /usr/share/logwatch/default.conf/html/
    fi
    #suppression du cron automatique de logwatch qui envoi un mail interne a personne
    cat /etc/cron.daily/00logwatch |grep -v "\-\-output mail"|grep -v "#execute" > /tmp/newcronlogwatch
    cat  /tmp/newcronlogwatch > /etc/cron.daily/00logwatch
    rm /tmp/newcronlogwatch 
    #recherche d'un email deja existant
    CURRENT=$(egrep -v "^#" /etc/cron.daily/00logwatch|grep "\-\-mailto"|cut -d" " -f 3) 
    echo "$CURRENT"
    pause
    # ask for a true email to send logwatch
    EMAIL=$(whiptail --inputbox "Saisir l'email de l'administrateur?" --title "Logwatch admin email" 8 78 "${CURRENT}"  3>&1 1>&2 2>&3)
    exitstatus=$?
    clear;
	if [ $exitstatus = 0 -a -n "$EMAIL" ]
	then
	   #ssuppresion de l'email courant pour le remplacer par celui saisi	
	   cat /etc/cron.daily/00logwatch |grep -v "\-\-mailto ${CURRENT}"> /tmp/newcronlogwatch
	   cat /tmp/newcronlogwatch > /etc/cron.daily/00logwatch
	   rm  /tmp/newcronlogwatch
	   echo "/usr/sbin/logwatch --mailto ${EMAIL} --format html --encode base64" >> /etc/cron.daily/00logwatch
	fi
    pause
}

#############################################################
# Installation  some security apps							#	
#############################################################
function install_security()  {
    print_info "installing Security Packages"
    disable_pause
    install_nmap
    install_logwatch
    install_denyhosts
    install_rkhunter
    install_chkrootkit
    # modifier la config de ssh pour améliorer la securité
    # passer PermitRootLogin yes a PermitRootLogin without-password par defaut
    # tester la config de sshd avec cette commande avant de la remplacer :) sshd -t -f /tmp/sshd_config 

    enable_pause
}

