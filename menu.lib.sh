######################################
# Main Menu             	     #	
######################################
function main_menu()
{

    while : # Loop forever
    do
    clear
    reset_menu
    set_menu_title "Main Menu"
    set_menu_query "Please select a tool"
    set_menu_quit "q" "Exit menu" 
    add_menu "Show shell tools" "shell_menu"
    add_menu "Show server tools" "server_menu"
    add_menu "Show Security tools" "security_menu"
    add_menu "Install Minimal Tools" "install_minimal_tools"
    show_menu

    case $result in
    q) exit ;;
    *) ${M_ACTIONS[result]};;
    esac
    done
}
######################################
# Server Menu                        #	
######################################
function server_menu() {
    source ./server-tool.sh
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
    b) break ;;
    *) ${M_ACTIONS[result]};;
    esac
    done
}
######################################
# Security Menu          	     #	
######################################
function security_menu() {


    source ./security-tool.sh
    while : # Loop forever
    do
    clear
    reset_menu
    set_menu_title "Security Tools"
    set_menu_query "What do you want to do"
    set_menu_quit "b" "Go Back" 
    add_menu "Show running progs" "list_progs"
    add_menu "Who is logged in" "who_is_logged"
    add_menu "Liste des ports ouverts" "run_nmap_local"
    add_menu "Analyser les logs" "run_logwatch"
    show_menu

    case $result in
    b) break ;;
    *) ${M_ACTIONS[result]};;
    esac
    done


}
######################################
# Shell Menu                         #	
######################################
function shell_menu() {

    source ./shell-tool.sh

    while : # Loop forever
    do
    clear
    reset_menu
    set_menu_title "Shell Tools"
    set_menu_query "Please select a tool"
    set_menu_quit "b" "Back" 
    add_menu "Install Cool bash colors" "install_cool_bash"
    add_menu "Install most" "install_most"
    add_menu "Install htop" "install_htop"
    add_menu "Install ntpdate" "install_ntpdate"
    add_menu "Install security packages" "install_security"
    show_menu

    case $result in
    b) break ;;
    *) ${M_ACTIONS[result]};;
    esac
    done

}