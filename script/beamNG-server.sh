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
README_URL="https://github.com/mrcodedev/beamng-server-script/blob/main/README.md"
BYE_TEXT="Bye ${USER}, see you later :D!"
DOWNLOAD_FOLDER="download"
DOWNLOAD_FILE_LOG="download.log"
SERVER_FOLDER="BeamNG-Server"
SERVER_CONFIG_FILE="ServerConfig.toml"
FOLDER_DATA_LOG="data"
FILE_NAME_LOG="file-name-download-server.dat"
FILE_PID_LOG="pid.dat"
LOG_FOLDER="logs"

# Version
VERSION=0.0.1

# Define variable colors
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

# Text colors
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

# Background colors
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
    echo -e "Status wget ${statusWget}"
    isInstalled curl
    echo -e "Status  ${statusWget}"
    urlExists $CLEAN_GITHUB_URL
    echo -e ""
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Downloading files${END_COLOR}"
    echo -e "========================="
    echo -e "💾 Starting to download file of BeamNG-Server..."
    sleep 2s
    downloadAndInstallServer
    echo -e "✅⬇️  Downloaded file!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    sleep 2s
}

prepareInstall() {
   downloadLogFileExists "./$DOWNLOAD_FOLDER/$DOWNLOAD_FILE_LOG"
   searchLogFile "./$DOWNLOAD_FOLDER/$DOWNLOAD_FILE_LOG"
}

isInstalled() {
    if !(dpkg -l | grep $1 > /dev/null); then
        echo -e "❌ '${1}' installed on the system - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        echo -e "You must install '${1}', run 'sudo apt install ${1}'."
        sayGoodbyeAfterError
    fi
    echo -e "✅ '${1}' installed on the system - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
}

urlExists() {
    echo "🔎 Checking GitHub URL environment..."
    if !(wget --spider -q $CLEAN_GITHUB_URL); then
        echo -e "❌ No exists URL $CLEAN_GITHUB_URL - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        echo -e "Check configure 'settings.env' and set a URL on GITHUB_URL_BEAMMP_SERVER"
        sayGoodbyeAfterError
    else
        echo -e "✅ URL exists $CLEAN_GITHUB_URL - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

downloadAndInstallServer() {
    mkdir -p $DOWNLOAD_FOLDER
    wget -o $DOWNLOAD_FOLDER/$DOWNLOAD_FILE_LOG -nc --progress=bar --show-progress -P ./$DOWNLOAD_FOLDER $CLEAN_GITHUB_URL
}

downloadLogFileExists() {
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Checking log and Copy the file server${END_COLOR}"
    echo -e "======================================"
    if [ ! -f $1 ]; then
        echo -e ""
        echo -e "❌ The download log file doesn't exist, try using the option 1 of the menu - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else
        echo -e "✅ The download log file exists :D - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

searchLogFile() {
    local LINE=$(grep "saved" "./$DOWNLOAD_FOLDER/$DOWNLOAD_FILE_LOG" | tail -n 1)
    local LINE_RETRY=$(grep "already there" "./$DOWNLOAD_FOLDER/$DOWNLOAD_FILE_LOG" | tail -n 1)

    if [[ -n $LINE ]]; then
        local FILE_NAME_WITH_PATH=$(echo "$LINE" | awk -F "[‘’']" '{print $2}')    
        local FILE_NAME=$(basename "$FILE_NAME_WITH_PATH" | sed 's/\\$//')
        local INFO_DOWNLOAD=$(echo "$LINE" | grep -oP '\[\K[0-9]+/[0-9]+')
        local DOWNLOADED=$(echo "$INFO_DOWNLOAD" | cut -d '/' -f 1)
        local TOTAL_DOWNLOAD=$(echo "$INFO_DOWNLOAD" | cut -d '/' -f 2)
        if [[ "$DOWNLOADED" != "$TOTAL_DOWNLOAD" ]]; then
            echo -e "❌ The file are wrong, delete download folder and start with the option 1... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
            sayGoodbyeAfterError
        fi
        copyAndInstallFile $FILE_NAME
        installFileServer $FILE_NAME
    elif [[ -n $LINE_RETRY ]]; then
        local FILE_NAME_RETRY=$(echo "$LINE_RETRY" | sed -n "s/.*‘.*\/\([^’]*\)’.*/\1/p")
        copyAndInstallFile $FILE_NAME_RETRY
        installFileServer $FILE_NAME_RETRY
    else
        echo -e "❌ The log download file is empty... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    fi
}

copyAndInstallFile() {
    mkdir -p "../${SERVER_FOLDER}/"
    mkdir -p "../${SERVER_FOLDER}/$FOLDER_DATA_LOG"

    if [[ ! -d "../$SERVER_FOLDER" ]]; then
        echo -e "❌ The folder to copy file server doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else
        echo -e "✅ Created folder of the server "../$SERVER_FOLDER/" - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 0.5s
    fi

    if [[ ! -d "../${SERVER_FOLDER}/$FOLDER_DATA_LOG" ]]; then
        echo -e "❌ The folder data log server doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else
        echo -e "✅ Created folder data log of the server "../$SERVER_FOLDER/" - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 0.5s
    fi

    if ! echo "$1" > "../${SERVER_FOLDER}/$FOLDER_DATA_LOG/$FILE_NAME_LOG"; then
        echo -e "❌ Don't create log file name server... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else 
        echo -e "✅ Created log folder file name server "../$SERVER_FOLDER/$FOLDER_DATA_LOG/$FILE_NAME_LOG" - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 0.5s
    fi

    cp "$DOWNLOAD_FOLDER/$1" "../$SERVER_FOLDER/"

    if [[ ! -f  "$DOWNLOAD_FOLDER/$1" ]]; then
        echo -e "❌ The downloaded file doesn't exist, use option 1... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else
        echo -e "✅ Copied file into "../$SERVER_FOLDER/$1" - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 0.5s
    fi
}

execCommandToInstall() {
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Installing BeamNG Server:${END_COLOR}"
    echo -e "================================"
    goToServerFolder && ./"$1"
    if [[ ! -f  ${SERVER_CONFIG_FILE} ]]; then
        echo -e "❌ The ServerConfig.toml file doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    else
        echo ""
        echo -e "🎉 BeamNG-Server installed satisfactorily!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        echo -e ""
        sleep 4s
        echo -e "🖊️  Do you want edit the AuthKey with nano editor??? (y/n)"
        nano_option=true
        while $nano_option; do
            read option_menu_nano
            case $option_menu_nano in
                "y"|"Y"|"yes"|"Yes") 
                    nano_option=false
                    nano ${SERVER_CONFIG_FILE};;
                "n"|"N"|"no"|"No")
                    nano_option=false;;
                *) echo -e "$(getColor $BOLD $RED_TEXT "")ERROR:${END_COLOR} Wrong option, choose another one...";; 
            esac
        done
        echo ""
        sleep 2s
        echo -e "✅ The server file is installed, if you hasn't edit the config file "$(pwd)/ServerConfig.toml" - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        echo -e ""
        echo -e "📖 More info in README.md repo in the Authentication Key section: ${README_URL}"
        echo -e "--------------------------------"
        echo "👁️  Press any key to continue..."
        read -n 1 -s
        goToScriptFolder
    fi
}

installFileServer() {
    if [[ ! -x  "../$SERVER_FOLDER/$1" ]]; then
        echo -e "⚠️ 🔒 Don't have permissions to run the server file, giving permissions... - $(getColor $BOLD $YELLOW_TEXT "")RETRY${END_COLOR}"
        sleep 2s
        chmod +x "../$SERVER_FOLDER/$1"
    fi

    if [[ -x  "../$SERVER_FOLDER/$1" ]]; then
        echo -e "✅🔓 You have permissions to run the app BeamNG Server - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 2s
        echo -e ""
        echo -e "$(getColor $BOLD $GREEN_TEXT "")Downloading necessary dependencies for installation${END_COLOR}"
        echo -e "==================================================="
        echo -e "Installing neccesary dependencies with 'sudo apt-get install:'"
        echo -e "liblua5.3-dev curl zip unzip tar cmake make git g++"
        sleep 3s

        if [[ ! $(sudo apt-get install liblua5.3-dev curl zip unzip tar cmake make git g++) ]]; then
            echo -e "❌⛔ Don't have the dependencies... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
            echo -e ""
            sayGoodbyeAfterError
        fi

        echo -e ""
        echo -e "$(getColor $BOLD $GREEN_TEXT "")Installing dependencies:${END_COLOR}"
        echo -e "================================"
        isInstalled liblua5.3-dev && isInstalled curl && isInstalled zip && isInstalled unzip && isInstalled tar && isInstalled cmake && isInstalled make && isInstalled git && isInstalled g++
        echo -e ""
        execCommandToInstall $1
    else 
        echo -e "❌🔒 Don't have permissions to run the server file, :(... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo ""
        sayGoodbyeAfterError
    fi
}

startServer() {
    echo -e ""
    echo -e "$(getColor $BOLD $GREEN_TEXT "")Checking before start:${END_COLOR}"
    echo -e "================================"
    sleep 2s
    goToServerFolder
    checkFileServer
    checkFileNameLogServer
    checkConfigFile
    checkAuthConfig
    checkLogFolder
    checkPID
    goToScriptFolder
    repeatOptions=true
}

checkFileNameLogServer() {
    local FILE_NAME_SERVER=$(cat $ $FOLDER_DATA_LOG/$FILE_NAME_LOG 2> /dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [[ ! -f  ${FILE_NAME_SERVER} ]]; then
        echo -e "❌ The log name server doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        sayGoodbyeAfterError
    else
        echo -e "✅ Exist the log name server :D!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

checkFileServer() {
    local FILE_SERVER_NAME=$(cat $FOLDER_DATA_LOG/$FILE_NAME_LOG)
    if [[ ! -f  ${FILE_SERVER_NAME} ]]; then
        echo -e "❌ The file server doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        sayGoodbyeAfterError
    else
        echo -e "✅ Exist the file server :D!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

checkConfigFile() {
     if [[ ! -f  ${SERVER_CONFIG_FILE} ]]; then
        echo -e "❌ The ServerConfig.toml file doesn't exist, use option 2... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e
        sayGoodbyeAfterError
    else
        echo -e "✅ Exist the $SERVER_CONFIG_FILE file config :D!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

checkAuthConfig() {
    local AUTH_KEY=$(grep '^AuthKey =' ServerConfig.toml | sed -n 's/^AuthKey = "\(.*\)"/\1/p')

    if [[ -z "$AUTH_KEY" ]]; then
        echo -e "❌ AuthKey has no value, you must give it a value, see the README to see how to do this - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e "📖 More info in README.md repo in the Authentication Key section: ${README_URL}"
        echo -e "--------------------------------"
        echo "👁️  Press any key to continue..."
        read -n 1 -s
        echo -e ""
        repeatMenu
    else
        echo -e "✅ AuthKey has a value: $AUTH_KEY - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi
}

checkLogFolder() {
    if [ ! -d "$LOG_FOLDER" ]; then
        echo -e "❌⚠️  The log folder doesn't exist, creating the folder... - $(getColor $BOLD $YELLOW_TEXT "")RETRY${END_COLOR}"
        mkdir -p $LOG_FOLDER
        echo -e "✅ Created log folder :D!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    fi

    if [ -d "$LOG_FOLDER" ]; then
        echo -e "✅ The log folder exists :D!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
    else
        echo -e "❌ The log folder doesn't exist, create the folder... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        echo -e ""
        sayGoodbyeAfterError
    fi
}

checkPID() {
    if [[ ! -f  "$FOLDER_DATA_LOG/$FILE_PID_LOG" ]]; then
        echo -e "✅ There is no server instance running... - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"    
    else
        echo -e "⚠️  An instance of the server is running... - $(getColor $BOLD $YELLOW_TEXT "")WARNING${END_COLOR}"
        echo -e ""
        echo -e "❓ Do you want to stop the instance, and run a new one??? (y/n)"
        kill_instance=true
        while $kill_instance; do
            read option_menu_instance
            case $option_menu_instance in
                "y"|"Y"|"yes"|"Yes") 
                    kill_instance=false
                    killPID;;
                "n"|"N"|"no"|"No")
                    kill_instance=false
                    echo ""
                    echo -e "👌 We don't stop the game instance, we return to the menu..."
                    sleep 4s;;
                *) echo -e "$(getColor $BOLD $RED_TEXT "")ERROR:${END_COLOR} Wrong option, choose another one...";; 
            esac
        done
    fi
}

killPID() {
    echo -e ""
    echo -e "🔎 Checking PID..."
    echo -e "==================="
    sleep 1s
    if (kill -9 $(cat $FOLDER_DATA_LOG/$FILE_PID_LOG)); then
        echo -e "✅ The PID was killed successfully!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"

        if > "$FOLDER_DATA_LOG/$FILE_PID_LOG" && [ ! -s "$FOLDER_DATA_LOG/$FILE_PID_LOG" ]; then
            echo -e "✅ The PID file is empty, we can start the server... - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        else
            echo -e "❌ The PID file is not empty, we can't start the server... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
            sayGoodbyeAfterError
        fi
        sleep 2s
        echo -e ""
        echo -e "🚀 Starting the server..."
        initServer
        echo -e "🎉 The server was started successfully!!! - $(getColor $BOLD $GREEN_TEXT "")OK${END_COLOR}"
        sleep 4s

    else
        echo -e "❌ The PID wasn't killed successfully... - $(getColor $BOLD $RED_TEXT "")ERROR${END_COLOR}"
        sayGoodbyeAfterError
    fi
}

initServer() {
    nohup ./BeamMP-Server.ubuntu.22.04.x86_64 > logs/server.log 2> logs/errors.log & echo $! > data/pid.dat
}

goToScriptFolder() {
    cd .. && cd script
}

goToServerFolder() {
    cd .. && cd "$SERVER_FOLDER"
}

sayGoodbyeAfterError() {
    sleep 2s
    echo -e "$BYE_TEXT"
    exit 1
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
                prepareInstall
                repeatMenu;;
            3|"start")
                startServer
                repeatMenu;;
            4|"stop")
                echo -e "Option $option selected";;
            5|"restart")
                echo -e "Option $option selected";;
            6|"status")
                echo -e "Option $option selected";;   
            7|"log")
                echo -e "Option $option selected";;
            t)
                echo -e "Testing selected"
                startServer;;
            *) echo -e "$(getColor $BOLD $RED_TEXT "")ERROR:${END_COLOR} Wrong option, choose another one...";; 
        esac
    done
}

initScript