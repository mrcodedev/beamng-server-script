#!/bin/bash

#####################################################################################
# BeamNG Linux Script                                                               #
# -------------------                                                               #
# Bash script for BeamNG for Linux Server                                           #
# If you want to automate the server in a VPS, and you don't know much about        #
# terminal commands, this is your script. Tested in Ubuntu.                         #
#                                                                                   #
# Author: MrCodeDev                                                                 #
# URL: https://github.com/mrcodedev                                                 #
# Ko-Fi: https://ko-fi.com/mrcodedev                                                #
#####################################################################################

# Global variables settings
source settings.env
CLEAN_GITHUB_URL=$(echo "$GITHUB_URL_BEAMMP_SERVER" | tr -d '\r')
BYE_TEXT="Bye :D!"

# Version
VERSION=0.0.1

# Define variable colours
END_COLOR="\e[0m"

# Styles
BOLD='1'
DIM='2'
ITALIC='3'
UNDERLINE='4'
BLINK='5'
REVERSE='7'
HIDDEN='8'
STRIKE='9'

# Colores de texto
BLACK_TEXT='30'
RED_TEXT='31'
GREEN_TEXT='32'
YELLOW_TEXT='33'
BLUE_TEXT='34'
MAGENTA_TEXT='35'
CYAN_TEXT='36'
WHITE_TEXT='37'
GRAY_LIGHT_TEXT='90'
RED_LIGHT_TEXT='91'
GREEN_LIGHT_TEXT='92'
YELLOW_LIGHT_TEXT='93'
BLUE_LIGHT_TEXT='94'
MAGENTA_LIGHT_TEXT='95'
CYAN_LIGHT_TEXT='96'
WHITE_LIGHT_TEXT='97'

# Colores de fondo
BLACK_BG='40'
RED_BG='41'
GREEN_BG='42'
YELLOW_BG='43'
BLUE_BG='44'
MAGENTA_BG='45'
CYAN_BG='46'
WHITE_BG='47'
GRAY_LIGHT_BG='100'
RED_LIGHT_BG='101'
GREEN_LIGHT_BG='102'
YELLOW_LIGHT_BG='103'
BLUE_LIGHT_BG='104'
MAGENTA_LIGHT_BG='105'
CYAN_LIGHT_BG='106'
WHITE_LIGHT_BG='107'

# Functions
getColor() {
    local textStyle="${1:-0}"
    local textColor="${2:-39}"
    local textBackground="${3:-49}"

    echo -ne "\e[${textStyle};${textColor};${textBackground}m"
}

getLogo() {
    echo -e "$(getColor $BOLD $RED_TEXT "")  ___                 $(getColor $BOLD $WHITE_TEXT "")_  _  ___   $(getColor $BOLD $YELLOW_TEXT "")___${END_COLOR}                      "
    echo -e "$(getColor $BOLD $RED_TEXT "") | _ ) ___ __ _ _ __ $(getColor $BOLD $WHITE_TEXT "")| \\| |/ __| $(getColor $BOLD $YELLOW_TEXT "")/ __| ___ _ ___ _____ _ _${END_COLOR}  "
    echo -e "$(getColor $BOLD $RED_TEXT "") | _ \\/ -_) _\` | '  \\$(getColor $BOLD $WHITE_TEXT "")| .\` | (_ | $(getColor $BOLD $YELLOW_TEXT "")\\__ \\/ -_) '_\\ V / -_) '_|${END_COLOR} "
    echo -e "$(getColor $BOLD $RED_TEXT "") |___/\\___\\__,_|_|_|_$(getColor $BOLD $WHITE_TEXT "")|_|\\_|\\___| $(getColor $BOLD $YELLOW_TEXT "")|___/\\___|_|  \\_/\\___|_|${END_COLOR}   "                                                        
}

showDataAuthor() {
    echo -e "============================================================"
    echo -e "$(getColor $BOLD $RED_TEXT "")Beam${END_COLOR}$(getColor $BOLD $WHITE_TEXT "")NG${END_COLOR} $(getColor $BOLD $YELLOW_TEXT "")Server Linux Script!${END_COLOR}"
    echo -e "By MrCodeDev"
    echo -e "$(getColor $BOLD $BLUE_TEXT "")GitHub:${END_COLOR} https://github.com/mrcodedev"
    echo -e "$(getColor $BOLD $BLUE_TEXT "")Ko-fi:${END_COLOR} https://ko-fi.com/mrcodedev"
    echo -e "$(getColor $BOLD $BLUE_TEXT "")Version:${END_COLOR} v${VERSION}"
    echo -e "$(getColor $BOLD $BLUE_TEXT "")Repo:${END_COLOR} https://github.com/mrcodedev/beamng-server-script"
    echo -e "============================================================"
}

showMenu() {
    echo -e ""
    echo -e "Select a option:"
    echo -e "================"
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")1) - Download File Server:${END_COLOR} Download."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")2) - Install Server:${END_COLOR} Install with folder config."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")3) - Start Server:${END_COLOR} Init the Server."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")4) - Stop Server:${END_COLOR} If the server is running, kill the process."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")5) - Restart Server:${END_COLOR} Restart the server."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")6) - Status Server:${END_COLOR} Check if the server is online."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")7) - Show Server Log:${END_COLOR} Read the log of the server."
    echo -e "  $(getColor $BOLD $BLUE_TEXT "")0) - Exit${END_COLOR}"
    echo -e ""
    echo -e "Type a number and press ENTER"
}

initScript() {
    getLogo
    showDataAuthor
    showMenu
    bucleMenu
}

repeatMenu() {
    showMenu
    repeatOptions=true
    bucleMenu
}

prepareDownload() {
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Checking tools to installation${END_COLOR}"
    echo -e "=================================="
    isInstalled wget
    echo "Status wget ${statusWget}"
    isInstalled curl
    echo "Status  ${statusWget}"
    urlExists $CLEAN_GITHUB_URL
    echo ""
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Downloading files${END_COLOR}"
    echo -e "========================="
    echo "💾 Starting to download file of BeamNG-Server..."
    sleep 2s
    downloadAndInstallServer
}

isInstalled() {
    if !(dpkg -l | grep $1 > /dev/null); then
        echo -e "❌ '${1}' installed on the system - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        echo -e "You must install '${1}', run 'sudo apt install ${1}'."
        sleep 2s
        echo -e "$BYE_TEXT"
        exit 1
    fi
    echo -e "✅ '${1}' installed on the system - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
}

urlExists() {
    echo "🔎 Checking GitHub URL environment..."
    if !(wget --spider -q $CLEAN_GITHUB_URL); then
        echo -e "❌ No exists URL $CLEAN_GITHUB_URL - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        echo -e "Check configure 'settings.env' and set a URL on GITHUB_URL_BEAMMP_SERVER"
        sleep 2s
        echo -e "$BYE_TEXT"
        exit 1
    else
        echo -e "✅ URL exists $CLEAN_GITHUB_URL - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

downloadAndInstallServer() {
    mkdir -p download
    wget -o download/download.log -nc --progress=bar --show-progress -P ./download $CLEAN_GITHUB_URL
}


bucleMenu() {
    while $repeatOptions; do
        read option
        echo ""
        case $option in
            0|"exit"|"q") 
                repeatOptions=false
                echo -e "Goodbye ${USER}, see you later!!! :D";;
            1|"download") 
                prepareDownload
                repeatMenu;;
            2|"install") 
                echo -e "Option $option selected";;
            3|"start")
                echo -e "Option $option selected";;
            4|"stop")
                echo -e "Option $option selected";;
            5|"restart")
                echo -e "Option $option selected";;
            6|"status")
                echo -e "Option $option selected";;   
            7|"log")
                echo -e "Option $option selected";;
            *) echo -e "$(getColor $BOLD $RED_TEXT "")ERROR:${END_COLOR} Wrong option, choose another one...";; 
        esac
    done
}

initScript