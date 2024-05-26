#!/bin/sh
#####################################################################################################################################################################
#                                                                    Installation Script for Quake 2                                                                #
#####################################################################################################################################################################
#                                                                                                                                                                   #
#                                                                                                                                                                   #
#                 AAA                                TTTTTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEEEEE               AAA               MMMMMMMM               MMMMMMMM  #
#                A:::A                               T:::::::::::::::::::::TE::::::::::::::::::::E              A:::A              M:::::::M             M:::::::M  #
#               A:::::A                              T:::::::::::::::::::::TE::::::::::::::::::::E             A:::::A             M::::::::M           M::::::::M  #
#              A:::::::A                             T:::::TT:::::::TT:::::TEE::::::EEEEEEEEE::::E            A:::::::A            M:::::::::M         M:::::::::M  #
#             A:::::::::A                            TTTTTT  T:::::T  TTTTTT  E:::::E       EEEEEE           A:::::::::A           M::::::::::M       M::::::::::M  #
#            A:::::A:::::A                                   T:::::T          E:::::E                       A:::::A:::::A          M:::::::::::M     M:::::::::::M  #
#           A:::::A A:::::A                                  T:::::T          E::::::EEEEEEEEEE            A:::::A A:::::A         M:::::::M::::M   M::::M:::::::M  #
#          A:::::A   A:::::A         ---------------         T:::::T          E:::::::::::::::E           A:::::A   A:::::A        M::::::M M::::M M::::M M::::::M  #
#         A:::::A     A:::::A        -:::::::::::::-         T:::::T          E:::::::::::::::E          A:::::A     A:::::A       M::::::M  M::::M::::M  M::::::M  #
#        A:::::AAAAAAAAA:::::A       ---------------         T:::::T          E::::::EEEEEEEEEE         A:::::AAAAAAAAA:::::A      M::::::M   M:::::::M   M::::::M  #
#       A:::::::::::::::::::::A                              T:::::T          E:::::E                  A:::::::::::::::::::::A     M::::::M    M:::::M    M::::::M  #
#      A:::::AAAAAAAAAAAAA:::::A                             T:::::T          E:::::E       EEEEEE    A:::::AAAAAAAAAAAAA:::::A    M::::::M     MMMMM     M::::::M  #
#     A:::::A             A:::::A                          TT:::::::TT      EE::::::EEEEEEEE:::::E   A:::::A             A:::::A   M::::::M               M::::::M  #
#    A:::::A               A:::::A                         T:::::::::T      E::::::::::::::::::::E  A:::::A               A:::::A  M::::::M               M::::::M  #
#   A:::::A                 A:::::A                        T:::::::::T      E::::::::::::::::::::E A:::::A                 A:::::A M::::::M               M::::::M  #
#  AAAAAAA                   AAAAAAA                       TTTTTTTTTTT      EEEEEEEEEEEEEEEEEEEEEEAAAAAAA                   AAAAAAAMMMMMMMM               MMMMMMMM  #
#                                                                                                                                                                   #
#####################################################################################################################################################################

# App Name      : Quake 2 + Quake 2 Launcher
# Author        : BigUncleMax (Quake 2 port for Sync 3) & Au{R}oN (Quake 2 Launcher)
# Creation date : 2024/05/26
# Version       : 0.9

###############################################################################
# Custom App Variables                                                        #
###############################################################################

APP_AUTHOR="auron89"        # FOLDER NAME USED TO GROUP APPS OF THE SAME DEVELOPER. NO SPACE OR SPECIAL CHARS ALLOWED!!
APP_NAME="Quake 2"          # VISIBLE DURING INSTALLATION PROCESS AND FROM APPS LOADER. ALL CHARS ALLOWED BUT SOME SPECIAL CHARS MAY CAUSE ISSUES
APP_FOLDER="quake2"         # APP FOLDER. NO SPACE OR SPECIAL CHARS ALLOWED!!
APP_FILE="Quake2.qml"       # MAIN APP FILE. NO SPACE OR SPECIAL CHARS ALLOWED, FIRST LETTER MUST BE IN UPPERCASE!!
APP_HIDETITLE="true"        # USED TO DEFINE IF TITLEBAR MUST REMAIN VISIBLE OR NOT. ONLY TRUE OR FALSE ALLOWED!!

AUTHOR="BigUncleMax"        # DEVELOPER NAME VISIBLE DURING THE INSTALLATION PROCESS. ALL CHARS ALLOWED BUT SOME SPECIAL CHARS MAY CAUSE ISSUES

###############################################################################
# Environment variables                                                       #
###############################################################################

PATH=/fs/rwdata/dev:$PATH

APIM_APPS_PATH=/fs/mp/fordhmi/qml/hmicustomapps/apps
APIM_JSON_PATH=/fs/mp/fordhmi/qml/hmicustomapps/apps.json
LOCAL_APP_PATH=/fs/usb0/SyncMyMod/app/

DISPLAY=/fs/tmpfs/status
POPUP=/tmp/popup.txt

# FMods Tools entries
MODTOOLS="FMODS_TOOLS"
MIN_MODTOOLS_VERSION="2.8"

DEPENDENCY="CUSTOM_APPS_LOADER"

FILES_DIR="/fs/usb0/SyncMyMod/files"
BIN_DIR="${FILES_DIR}/bin"
SHELL_DIR="${FILES_DIR}/shell"
OTHER_DIR="${FILES_DIR}/other"

KEEP_SAVED_GAMES=1
MOD_DATA_DIR="${OTHER_DIR}/quake2"
FMODS_DATA_DIR=/fs/images/fmods_apps_data
INSTALLATION_DIR=${FMODS_DATA_DIR}/Quake2/
BACKUP_DIR=${FMODS_DATA_DIR}/Quake2_bak

VERSION=$(cat ${OTHER_DIR}/quake2/version.txt)
PREV_VERSION=$(cat ${FMODS_DATA_DIR}/Quake2/version.txt)

LOG_DIR="/fs/usb0"
LOG_FILE=/tmp/install_status.txt
HWINFO_FILE=/tmp/hardware_info.txt

###############################################################################
# Functions                                                                   #
###############################################################################
dump_logs() {
	cp "${LOG_FILE}" "${LOG_DIR}"/install_status.txt
	sync
}

output() {
    echo "${1}" > "$DISPLAY"
    echo "${1}" >> $LOG_FILE
	sleep "${2}"
}

progress() {
    echo "PROGRESS ${1}" > "$DISPLAY"
}

displayMessage() {
    echo "${1}" >> "$POPUP"
    utserviceutility popup "$POPUP"
	
	exit 0
}

installationTerminated() {
	while [ -e /fs/usb0 ]; do
		sleep 1
	done
	
	output "REBOOT" 3
	exit 0
}

collectHwInfo() {
	echo "### HW INFO ###" > ${HWINFO_FILE}

	echo "\n### hwid ###" >> ${HWINFO_FILE}
	hwid >> ${HWINFO_FILE}

	echo "\n### OS version ###" >> ${HWINFO_FILE}
	cat  /fs/mp/Version.inf >> ${HWINFO_FILE}
	echo "" >> ${HWINFO_FILE}

	echo "\n### Installed mods ###" >> ${HWINFO_FILE}
	cat /fs/mp/etc/installed_mods.txt >> ${HWINFO_FILE}

	echo "\n### df -h ###" >> ${HWINFO_FILE}
	df -h >> ${HWINFO_FILE}

	cp ${HWINFO_FILE} ${LOG_DIR}/hardware_info.txt
	sync
}

###############################################################################
# Start mod installation                                                      #
###############################################################################

echo "Starting installation of ${APP_NAME} v${VERSION}..." > "$LOG_FILE"
collectHwInfo

###############################################################################
# Check if FMods Tools 2.5 is installed                                       #
###############################################################################

if ! grep -q ${MODTOOLS} /fs/rwdata/dev/mods_tools.txt; then
    displayMessage "FMods Tools not found. Installation aborted."
else
    LINE=$(grep "$MODTOOLS" /fs/rwdata/dev/mods_tools.txt)
    MODS_TOOLS_VERSION=$(echo "$LINE" | awk -F'_' '{print $NF}')
    
    if ! awk 'BEGIN {exit !('"$MODS_TOOLS_VERSION"' >= '"$MIN_MODTOOLS_VERSION"') }'; then
        displayMessage "FMods Tools ${MIN_MODTOOLS_VERSION} or higher not found. Installation aborted."
    fi
fi

###############################################################################
# Launch Installer Utility                                                    #
###############################################################################

cp -r ${OTHER_DIR}/images/* /tmp
sleep 1

instutility &
sleep 2

output "DEV ${APP_NAME} v${VERSION} - Developed by ${AUTHOR}" 2

###############################################################################
# Check if Custom Apps Loader is installed                                    #
###############################################################################

progress 5
output "Checking if Custom Apps Loader is installed..." 2

grep -q ${DEPENDENCY} /fs/mp/etc/installed_mods.txt
if [ $? -ne 0 ]; then
	output "ERROR Custom Apps Loader not installed. Please install it."
	installationTerminated
fi

###############################################################################
# Remount FS as RW                                                            #
###############################################################################

progress 7
output "Setting RW permissions to FS..." 1
remount_rw.sh
sleep 1

################################################################################
# Copying new files                                                            #
################################################################################

output "Detecting previous ${APP_NAME} installation..."
progress 10
sleep 3

if [ -z "$(jq -r --arg appName "${APP_NAME}" '.apps[] | select(.appName == $appName) | .appName' "$APIM_JSON_PATH")" ]; then
    progress 25
    output "Previous installation not detected. Adding JSON entry for Apps Launcher..." 2
    mkdir -p "${APIM_APPS_PATH}"/"${APP_AUTHOR}"/"${APP_FOLDER}"

    jq --arg appName "${APP_NAME}" \
       --arg appAuthor "${APP_AUTHOR}" \
       --arg appFolder "${APP_FOLDER}" \
       --arg appFile "${APP_FILE}" \
       --arg appIcon "${APP_AUTHOR}"/"${APP_FOLDER}"/Icon \
       --argjson appHideTitle "${APP_HIDETITLE}" \
       '.apps += [{"appName": $appName, "appFile": "\($appAuthor)/\($appFolder)/\($appFile)", "appIcon": $appIcon, "appHideTitle": $appHideTitle}]' \
       "$APIM_JSON_PATH" > /tmp/tmp.json
    mv /tmp/tmp.json "$APIM_JSON_PATH"
else
    progress 35
    output "Previous ${APP_NAME} version ${PREV_VERSION} detected." 2
	progress 35
	sleep 2

	progress 40
	if [ ${KEEP_SAVED_GAMES} -eq 1 ] && \
	   [ -d ${INSTALLATION_DIR}/baseq2/save ]; then
		output "Backup save game files..."

		rm -rf ${BACKUP_DIR}
		mkdir -p ${BACKUP_DIR}
		mv ${INSTALLATION_DIR}/baseq2/save ${BACKUP_DIR}/
	fi
	sleep 3
fi

progress 50
output "Installing ${APP_NAME} App Launcher files..."
cp ${SHELL_DIR}/quake2_launcher.sh	/fs/mp/scripts
cp -R ${LOCAL_APP_PATH}/*	$APIM_APPS_PATH/$APP_AUTHOR/$APP_FOLDER
chmod +x /fs/mp/scripts/quake2_launcher.sh
chmod +x $APIM_APPS_PATH/$APP_AUTHOR/$APP_FOLDER/uninstall.sh
sleep 3

progress 70
output "Installing ${APP_NAME} game files... please wait.. it might take a bit."
rm -rf ${INSTALLATION_DIR}
mkdir -p ${INSTALLATION_DIR}
cp -rv ${MOD_DATA_DIR}/* ${INSTALLATION_DIR}/ >> $LOG_FILE
if [ $? -ne 0 ]; then
	output "ERROR Installation error. Check log on USB stick."
	installationTerminated
fi

progress 80
output "Configuring files permissions..."
chmod +x ${INSTALLATION_DIR}/my-hid
chmod +x ${INSTALLATION_DIR}/quake2-gles2
chmod +x ${INSTALLATION_DIR}/quake2_start.sh
sleep 1

progress 85
if [ -d ${BACKUP_DIR}/save ]; then
	echo "Restore saved games..." > $DISPLAY

	mv ${BACKUP_DIR}/save ${INSTALLATION_DIR}/baseq2
	rm -rf ${BACKUP_DIR}
	sleep 3
fi

###############################################################################
# Remount FS as RW                                                            #
###############################################################################

progress 95
output "Setting RO permissions to FS..." 1
remount_ro.sh
sync
sync
sync

###############################################################################
# Display success image and reboot                                            #
###############################################################################

progress 100
output "Installation completed. Please remove the USB stick to reboot."
installationTerminated
