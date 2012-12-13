#!/bin/bash
#################################################################
# Program: Librairie de fonction utilitaire					#
#################################################################
# Version: 0.1
# Date: 30/11/2012
# Author:  Sébastient THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
#
#
#####################################################################



######################################
# Utility Fonction		     		 #	
######################################

#################################################################
# End process with en error $message						    #
# usage : 	die $message	    							# 
#################################################################

function die {
    echo -e '\e[1;31mERROR : '$1'\e[0m'> /dev/null 1>&2
    exit 1
}
#################################################################
# Display a warning $message      							    #
# usage : 	print_warn $message	    							# 
#################################################################

function print_warn {
	printf "\e[1;33m' $1 '\e[0m\n"
 }
#################################################################
# Display a Information $message      						    #
# usage : 	print_info $message	    							# 
#################################################################
function print_info {
    printf "\e[1;36m $1 \e[0m\n"
}
#################################################################
# Display a Information $message      						    #
# usage : 	print_info $message	    							# 
#################################################################
function print_info {
    printf "\e[1;36m $1 \e[0m\n"
}
#################################################################
# Scan network with $ipmask and list ip				#
# usage : scan_netwok $ipmask (10.42.0.0/24)    		#
#################################################################
function scan_network {
 nmap -sP  $1
}
#################################################################
# Display a $message and wait for a key press		        #
# usage : 	pause    					# 
#################################################################
function pause {
   read -p 'Press [Enter] key to continue...'
}
#################################################################
# Check if we are root on a debian distribution    		   	    #
# usage : 	check_sanity    									# 
#################################################################
function check_sanity {
    # Do some sanity checking.
    if [ $(/usr/bin/id -u) != "0" ]
    then
		die 'Must be run by root user'
    fi

	if [ ! -f /etc/debian_version ]
    then
		die "Distribution is not supported"
    fi
}
#####################################################################
# Check if $binary is present if not install $packages        	    #
# usage : 	check_and_install $binary $package1 $package2 $packageN	    # 
#####################################################################
function check_and_install {
    if [ -z "`which "$1" 2>/dev/null`" ]
    then
		executable=$1
        shift
		while [ -n "$1" ]
        do
			DEBIAN_FRONTEND=noninteractive apt-get -q -y install "$1"
            print_info "$1 installed for $executable"
            shift
		done
	else
		print_warn "$1 already installed"
    fi
}
#####################################################################
# install $packages        	    #
# usage : install_package $package1 $package2 $packageN	    # 
#####################################################################
function install_package {
   while [ -n "$1" ]
   do
  	DEBIAN_FRONTEND=noninteractive apt-get -q -y install "$1"
    print_info "$1 installed"
    shift
   done
}
#####################################################################
# Check if $binary is present if not install $packages        	    #
# usage : 	check_install $binary $package1 $package2 $packageN # 
#####################################################################
function check {
    if [ -z "`which "$1" 2>/dev/null`" ]
    then
 		return 0
	else
    
		return 1
    fi
}
#####################################################################
# Check if $binary is present if not install $packages        	    #
# usage : 	check_install $binary $package1 $package2 $packageN # 
#####################################################################
function check_apt_source {
	depot=$1
	local result=$(cat /etc/apt/sources.list|egrep -v "^#"|grep "${depot}"|wc -l 2> /dev/null)
    return $result
}
#####################################################################
# Check if $binary is present if not install $packages        	    #
# usage : 	check_install $binary $package1 $package2 $packageN # 
#####################################################################

function create_sql_db {
    MYSQL=`which mysql`
    clear
    printf "\e[01;32mEnter Database information to create\e[00m\n"
    printf "\
    printf "\e[00;e[00;33mUsername : \e[00m"
    read DB_USER
    printf "\e[00;33mHost : \e[00m"
    read DB_HOST
    printf "\e[00;33mPassword : \e[00m"
    read DB_PASSWORD
    printf "\e[00;33mDatabase name : \e[00m"
    read DB_NAME
    printf "\e[00;32mEnter root passord for creating database and user\e[00m\n"
    printf "\e[00;31mRoot password: \e[00m"
    read DB_ROOT_PASSWORD

    Q1="CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
    Q2="GRANT ALL ON *.* TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}';"
    Q3="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}"

    $MYSQL -uroot -p$DB_ROOT_PASSWORD -e "$SQL"
}
