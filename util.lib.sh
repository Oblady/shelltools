#!/bin/bash
#################################################################
# Program: Librairie de fonction utilitaire					#
#################################################################
# Version: 0.1
# Date: 30/11/2012
# Author:  Sébastien THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
#
#
#####################################################################
######################################
# Define a few Color's				 #
######################################
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color
######################################
# Some Global Var			 #
######################################
export APP_PAUSABLE="on"
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
#function pause {
#   read -p ''
#}
function pause()
{
	if [ x$APP_PAUSABLE =  'xon' ] 
	then 	
      key=""
      echo -n  "Press any key to continue..."
      stty -icanon
      key=`dd count=1 2>/dev/null`
      stty icanon
     fi
}
#################################################################
# Disable the pause mechanisme							        #
# usage : 	disable_pause    											# 
#################################################################
disable_pause()
{
	APP_PAUSABLE='off' 
}
#################################################################
# enable the pause mechanisme							        #
# usage : 	disable_pause    											# 
#################################################################
enable_pause()
{
	APP_PAUSABLE='on' 
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
# Check if $depot is present in apt sources list     	    #
# usage : 	check_apt_source $despot # 
#####################################################################
function check_apt_source {
	depot=$1
	local result=$(cat /etc/apt/sources.list|egrep -v "^#"|grep "${depot}"|wc -l 2> /dev/null)
    return $result
}
#####################################################################
# Check if $string is present in $config file    	    #
# usage : 	check_config $string $file # 
#####################################################################
function check_config {
	local config_string=$1
	local config_file=$2
	local result=$(cat "${config_file}"|egrep -v "^#"|grep "${config_string}"|wc -l 2> /dev/null)
    return $result

}

#####################################################################
# Test Color :)										        	    #
# usage : test_color												# 
#####################################################################
function test_color {

   	printf "${BLACK}BLACK${NC}\n"
 	printf "${BLUE}BLUE${NC}\n"
 	printf "${GREEN}GREEN${NC}\n"
 	printf "${CYAN}CYAN${NC}\n"
 	printf "${PURPLE}PURPLE${NC}\n"
 	printf "${BROWN}BROWN${NC}\n"
 	printf "${LIGHTGRAY}LIGHTGRAY${NC}\n"
 	printf "${DARKGRAY}DARKGRAY${NC}\n"
 	printf "${LIGHTBLUE}LIGHTBLUE${NC}\n"
 	printf "${LIGHTGREEN}LIGHTGREEN${NC}\n"
 	printf "${LIGHTCYAN}LIGHTCYAN${NC}\n"
 	printf "${LIGHTRED}LIGHTRED${NC}\n"
 	printf "${LIGHTPURPLE}LIGHTPURPLE${NC}\n"
 	printf "${YELLOW}YELLOW${NC}\n"
 	printf "${WHITE}WHITE${NC}\n"
    pause
}
#####################################################################
# Trim string 									        	    #
# usage : trim $string												# 
#####################################################################
trim() {
    local var=$1
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

#####################################################################
# Test pause function :)										        	    #
# usage : test_pause												# 
#####################################################################
function test_pause() {
	
	echo 'pausable state '$APP_PAUSABLE
	pause
	disable_pause
	echo "app is not more pausable "
	echo 'pausable state '$APP_PAUSABLE
	pause
	enable_pause
	echo "app is pausable again "
	echo 'pausable state '$APP_PAUSABLE
	pause
	
}



##########################################################################
# add a new entry to a menu when you select $label $action will be run   #
# usage : 	add_menu $label  $action     								 # 
##########################################################################
function add_menu()
{ 
  POS=$((($M_INDEX-1)*2))
  M_CHOICES[POS]=$M_INDEX 	
  M_CHOICES[POS+1]=$1
  M_ACTIONS[M_INDEX]=$2
  ((M_INDEX++))  	
}
#####################################################################
# empty menu item and action						        	    #
# usage : 	reset_menu											    # 
#####################################################################
function reset_menu(){
	M_INDEX=1
	unset M_CHOICES
	unset M_ACTIONS	
	unset M_TITLE
	unset M_QUERY
	unset M_QUIT_KEY
	unset M_QUIT_LABEL
	
}
#####################################################################
# set the menu title								        	    #
# usage : 	set_menu_title $title								    # 
#####################################################################
function set_menu_title(){
	M_TITLE=$@
}
#####################################################################
# set the menu query								        	    #
# usage : 	set_menu_query $query								    # 
#####################################################################
function set_menu_query(){
	M_QUERY=$@
}
#################################################################################################
# set the menu entry for exit menu, when you select	$label , $key will be result        	    #
# usage : 	set_menu_quit $key $label 											    		    # 
#################################################################################################
function set_menu_quit(){
	M_QUIT_KEY=$1
	M_QUIT_LABEL=$2
}
#################################################################################################
# display the menu configured before												     	    #
# usage : 	show_menu				 											    		    # 
#################################################################################################
function show_menu() {
	LINES=$(tput lines)
	COLUMNS=$(tput cols)	
	M_HEIGHT=$(($LINES-20))
	M_WIDTH=$(($COLUMNS-30))
	S_HEIGHT=$(($M_HEIGHT-10))
        result=$(whiptail --clear --nocancel --title "$M_TITLE" --menu "$M_QUERY"  $M_HEIGHT $M_WIDTH $S_HEIGHT "${M_CHOICES[@]}"	"$M_QUIT_KEY" "$M_QUIT_LABEL"  3>&2 2>&1 1>&3-)
        clear
}

#####################################################################
# Create a database and a user, give access to the database to user #
# usage : 	create_sql_db											# 
#####################################################################

function create_sql_db {
    MYSQL=`which mysql`
    clear
    printf "\e[01;32mEnter Database information to create\e[00m\n"
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
