#!/bin/bash
#################################################################
# Program: Server tool						#
#################################################################
# Version: 0.1
# Date: 30/11/2012
# Author:  Sébastien THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
# Todo :
#  - installer mysql optimiser clustering ?
#  - installer pour mongodb
#  - installer serveur sql uniquement (mysql + what )
#  - installer pour phpmyadmin 
#  - installer pour postfixadmin + roundcube ?
#  - installer pour munin-node et config des plugins
#  - installer pour monit
#  - config de backuppc + dump_sql.sh
#  - installer snmp et autre truc  (npre) pour centreon/nagios
#  - install d'un serveur mail complet ? (postfix, postfix admin, roundcube + dovecot )
#  - install d'un serveur solr ?
#  - install du bashrc ui va bien
#  - install de NTP
#  - configuration timezone php5
#  - tester les fichier de l'application au demarrage 
#  TODO Server Web 
#   creation d'un vhost apache/nginx
#   creation d'un user mysql
#   creation d'une instance de dev
#    - creation du vhost, du git, installation clef ssh jenkins,
#  TODO xen Ganeti
#  - install des modules manquant pour machine ganeti
#  - configuration de tzdata
#  - reconfiguration des locales 
#####################################################################

source ./util.lib.sh
######################################
# NGINX installer 		     		 #	
######################################
function install_nginx {
	print_info "installing nginx"
    if check nginx &> /dev/null  # Suppress output.
	then
	    # verification des depots nginx dans apt
		if check_apt_source "nginx.org/packages/debian" 
		then
		    #si KO ajout depot + ajout clef
			print_warn	"nginx depot absent installation"
			echo "" >> /etc/apt/sources.list
			echo "#Nginx" >> /etc/apt/sources.list
			echo "deb http://nginx.org/packages/debian/ squeeze nginx" >> /etc/apt/sources.list
			echo "deb-src http://nginx.org/packages/debian/ squeeze nginx" >> /etc/apt/sources.list
			echo "" >> /etc/apt/sources.list
			cd /tmp
			wget  -q http://nginx.org/keys/nginx_signing.key
			cat nginx_signing.key | apt-key add - &> /dev/null
			rm nginx_signing.key 
			apt-get -qq update 
			cd -
		else 
			print_info	"nginx depot present"
		fi
	    
	    #install nginx	 
	    install_package nginx
	else 
		print_info	"nginx already installed"
	fi	
    pause
}
######################################
# Varnish installer		     	 #	
######################################
#PHP5 FPM
# varnish
#deb http://repo.varnish-cache.org/debian/ squeeze varnish-3.0
function install_varnish {
	print_info "installing Varnish"
    if check varnishd &> /dev/null  # Suppress output.
	then
	    # verification des depots dotdeb dans apt
		if check_apt_source "repo.varnish-cache.org" 
		then
		    #si KO ajout depot + ajout clef
			print_warn	"varnish cache depot absent installation"
			echo "" >> /etc/apt/sources.list
			echo "#Varnish" >> /etc/apt/sources.list
			echo "deb http://repo.varnish-cache.org/debian/ squeeze varnish-3.0" >> /etc/apt/sources.list
			echo "" >> /etc/apt/sources.list
			cd /tmp
			wget -q http://repo.varnish-cache.org/debian/GPG-key.txt
			cat GPG-key.txt | apt-key add - &> /dev/null
			rm GPG-key.txt 
			apt-get -qq update 
			cd -
		else 
			print_info	"varnish cache depot present"
		fi
	    
	    #install varnish	 
	    install_package varnish
	else 
		print_info	"varnish already installed"
	fi	
    pause
}
######################################
# PHP5 installer	   	 #	
######################################
function install_php5 {
	
	if ! check nginx &> /dev/null  # Suppress output.
	then
	   install_php5_fpm
	fi
	if ! check apache2ctl &> /dev/null  # Suppress output.
	then
	   install_php5_mod
	fi

}
######################################
# PHP5 apache module installer	   	 #	
######################################
function install_php5_mod {
	print_info "installing PHP5 MOD"
    check_and_install php5 libapache2-mod-php5 php5-cli php5-mysql php5-apc php5-curl
    pause
}
######################################
# PHP5 FPM installer		     	 #	
######################################
#PHP5 FPM
#deb http://packages.dotdeb.org stable all
#deb-src http://packages.dotdeb.org stable all
function install_php5_fpm {
	print_info "installing PHP5 FPM"
    if check php5-fpm &> /dev/null  # Suppress output.
	then
	    # verification des depots dotdeb dans apt
		if check_apt_source "packages.dotdeb.org" 
		then
		    #si KO ajout depot + ajout clef
			print_warn	"dotdeb depot absent installation"
			echo "" >> /etc/apt/sources.list
			echo "#DOTDEB" >> /etc/apt/sources.list
			echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
			echo "deb-src http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
			echo "" >> /etc/apt/sources.list
			cd /tmp
			wget -q http://www.dotdeb.org/dotdeb.gpg
			cat dotdeb.gpg | apt-key add - &> /dev/null
			rm dotdeb.gpg 
			apt-get -qq update 
			cd -
		else 
			print_info	"dot deb depot present"
		fi
	    
	    #install php5-fpm	 
	    install_package php5-fpm php5-cli php5-mysql php5-apc php5-curl
	else 
		print_info	"php5-pfm already installed"
	fi	
    pause
}
######################################
# Munin Server 2 installer		     	 #	
######################################
#backport pour munin 2
#deb http://backports.debian.org/debian-backports squeeze-backports main
function install_munin_server {
	print_info "installing Munin Server"
    if check munin-check &> /dev/null  # Suppress output.
	then
	    # verification des depots dotdeb dans apt
		if check_apt_source "backports.debian.org/debian-backports" 
		then
		    #si KO ajout depot
			print_warn	"backport depot absent installation"
			echo "" >> /etc/apt/sources.list
			echo "#backport pour munin 2" >> /etc/apt/sources.list
			echo "deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list
			echo "" >> /etc/apt/sources.list
			apt-get -qq update 
		else 
			print_info	"backports  depot present"
		fi
	    
	    #install munin	 server 
	    DEBIAN_FRONTEND=noninteractive apt-get -q -y install -t squeeze-backports munin
	else 
		print_info	"Munin Server already installed"
	fi	
    pause
}
######################################
# Mysql installer		     #	
######################################
function install_mysql {
    print_info "installing Mysql"
    check_and_install mysql mysql-server
    pause
}

######################################
# Postfix installer		     #	
######################################
function install_postfix {
    print_info "installing Postfix"
    check_and_install postfix postfix
    pause
}

######################################
# Nullmailer installer		     #	
######################################
function install_nullmailer {
    print_info "installing nullmailer"
    check_and_install sendmail nullmailer
    pause
}

######################################
# Dovecot installer		     #	
######################################
function install_dovecot {
    print_info "installing dovecot"
    check_and_install dovecot dovecot-common dovecot-imapd dovecot-pop3d sasl2-bin libsasl2-modules 
    pause
}


######################################
# graphicsmagick installer	     #	
######################################
function install_graphicsmagick {
	print_info "installing graphicsmagick"
    check_and_install gm  graphicsmagick
    if check php5  
	then
	  install_package php5-imagick graphicsmagick-imagemagick-compat
    fi 
    pause
}

######################################
# nginx fullhosting installer        #	
######################################
function install_nginx_fullhosting {
	print_info "installing nginx hosting with nginx + php5 + sql + mailer"
    apt-get -qq update
    install_nginx
    install_php5
    install_mysql
    install_postfix

}
######################################
# nginx frontend installer		     	 #	
######################################
function install_nginx_frontend {
	print_info "installing nginx frontend with nginx + php5 + nullmailer"
    apt-get -qq update
    install_nginx
    install_php5
    install_nullmailer
}

######################################
# apache fullhosting installer		     	 #	
######################################
function install_apache_fullhosting {
	print_info "installing apache hosting with apache2 + php5 + sql + mailer"
    apt-get -qq update
    install_apache
    install_php5
    install_mysql
    install_postfix

}
######################################
# apache frontend installer	    	 #	
######################################
function install_apache_frontend {
    print_info "installing apache frontend with apache2 + php5 + nullmailer"
    apt-get -qq update
    install_apache
    install_php5
    install_nullmailer
}


######################################
# Webmail installer	    	 #	
######################################
function install_full_webmail {
    print_info "installing a webmail nginx+php5+mysql+postfix+dovecot "
    apt-get -qq update
    install_nginx
    install_php5
    install_postfix
    install_mysql 
    install_dovecot
    install_package php5-imap postfix-mysql 
    CURRENT_DIR=$(pwd) 
    cd /tmp
    rm -fr postfixadmin-2.3.*
    wget -O postfixadmin.tar.gz http://sourceforge.net/projects/postfixadmin/files/latest/download?source=files   
    tar -zxvf postfixadmin.tar.gz
    mv postfixadmin-2.3.* postfixadmin
    
    
    cd $CURRENT_DIR
}


######################################
# Start Of Programme	     		 #	
######################################

check_sanity
while : # Loop forever
do
clear
reset_menu
set_menu_title "Shell Tools"
set_menu_query "Please select a tool"
set_menu_quit "b" "Back" 
add_menu "Install Nginx" "install_nginx"
add_menu "Install apache" "install_apache"
add_menu "Install PHP5" "install_php5"
add_menu "Install Mysql" "install_mysql"
add_menu "Install postfix" "install_postfix"
add_menu "Install nullmailer" "install_nullmailer"
add_menu "Install graphicsmagick" "install_graphicsmagick"
add_menu "Install nginx fullhosting" "install_nginx_fullhosting"
add_menu "Install nginx frontend" "install_nginx_frontend"
add_menu "Install apache fullhosting" "install_nginx_fullhosting"
add_menu "Install apache frontend" "install_nginx_frontend"
add_menu "Install Munin Server" "install_munin_server"
show_menu

case $result in
b) exit ;;
*) ${M_ACTIONS[result]};;
esac
done
