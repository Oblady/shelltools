#!/bin/bash
#################################################################
# Program: Admin tool's						#
#################################################################
# Version: 0.1
# Date: 01/12/2012
# Author:  Sébastien THIBAULT <sebastien@oblady.fr>
#
# Notes: 
#
#  A set of tools for debian admin :) 
#
#################################################################*
source ./util.lib.sh
check_sanity;


while : # Loop forever
do
clear
reset_menu
set_menu_title "Main Menu"
set_menu_query "Please select a tool"
set_menu_quit "q" "Exit menu" 
add_menu "Show shell tools menu" "./shell-tool.sh"
add_menu "Show server tools menu" "./server-tool.sh"
add_menu "Show security tools menu" "./security-tool.sh"
add_menu "test pause" "test_pause"
show_menu

case $result in
q) exit ;;
*) ${M_ACTIONS[result]};;
esac
done

