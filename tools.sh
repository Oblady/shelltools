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
#  TODO xen Ganeti
#  - install des modules manquant pour machine ganeti
#  - configuration de tzdata
#  - reconfiguration des locales 
#################################################################*
source ./util.lib.sh
source ./menu.lib.sh

function install_minimal_tools() 
{
   source ./shell-tool.sh
   source ./security-tool.sh
   print_info "Installl a bunch of usefull package"
   disable_pause
   install_cool_bash
   install_makepasswd
   install_htop
   install_most
   install_ntpdate
   install_security
   enable_pause

}

check_sanity;

main_menu;
