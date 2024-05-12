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
# Creation date : 2024/05/07
# Version       : 0.3

###############################################################################
# Custom App Variables                                                        #
###############################################################################

APP_AUTHOR="auron89"		# NO SPACE OR SPECIAL CHARS ALLOWED!!
APP_NAME="Quake 2"		# ALL CHARS ALLOWED BUT SOME SPECIAL CHARS MAY CAUSE ISSUES
APP_FOLDER="quake2"		# NO SPACE OR SPECIAL CHARS ALLOWED!!
APP_FILE="Quake2.qml"		# NO SPACE OR SPECIAL CHARS ALLOWED, FIRST LETTER MUST BE IN UPPERCASE!!
APP_HIDETITLE="true"		# ONLY TRUE OR FALSE ALLOWED!!

###############################################################################
# Environment Variables                                                       #
###############################################################################

# Mod Name and Version
FANCYNAME="Quake 2 v0.3"

# Developer Name
AUTHOR="BigUncleMax"

# Required Mod
DEPENDENCY="CUSTOM_APPS_LOADER"

# FMods Tools 2.5 entry string
MODTOOLS="FMODS_TOOLS_2.5"

APIM_APPS_PATH=/fs/mp/fordhmi/qml/hmicustomapps/apps
APIM_JSON_PATH=/fs/mp/fordhmi/qml/hmicustomapps/apps.json
LOCAL_APP_PATH=/fs/usb0/SyncMyMod/app/

FILES_DIR="/fs/usb0/SyncMyMod/files"
BIN_DIR="${FILES_DIR}/bin"
SHELL_DIR="${FILES_DIR}/shell"
OTHER_DIR="${FILES_DIR}/other"

DISPLAY=/fs/tmpfs/status

KEEP_SAVED_GAMES=1
MOD_DATA_DIR="${OTHER_DIR}/quake2"
FMODS_DATA_DIR=/fs/images/fmods_apps_data
INSTALLATION_DIR=${FMODS_DATA_DIR}/Quake2/
BACKUP_FOLDER=${INSTALLATION_DIR}/Quake2_bak

DISPLAY=/fs/tmpfs/status
POPUP=/tmp/popup.txt

###############################################################################
# Functions                                                                   #
###############################################################################

function reboot {
	/fs/rwdata/dev/utserviceutility reboot
}

function installationTerminated {
	while [ -e /fs/usb0 ]; do
		sleep 1
	done

	slay -s 9 $INSTUTILITY_PID

	reboot

	exit 0
}

function output {
	echo "${1}" > $DISPLAY
	sleep ${2}
}

function progress {
	echo "PROGRESS ${1}" > $DISPLAY
}

function displayMessage {
	echo "${1}" >> $POPUP
	/fs/rwdata/dev/utserviceutility popup $POPUP
}

###############################################################################
# Check if FMods Tools 2.5 is installed                                       #
###############################################################################

grep -q ${MODTOOLS} /fs/rwdata/dev/mods_tools.txt
if [ $? -ne 0 ]; then
	displayMessage "FMods Tools 2.5 not found. This app REQUIRE that package."
	exit 0
fi

###############################################################################
# Launch Installer Utility                                                    #
###############################################################################

cp -r ${OTHER_DIR}/images/* /tmp
chmod a+x /fs/rwdata/dev/*
sleep 1

/fs/rwdata/dev/instutility &
INSTUTILITY_PID=$!
sleep 2

output "DEV ${FANCYNAME} - Developed by ${AUTHOR}" 2

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
. /fs/rwdata/dev/remount_rw.sh
sleep 1

################################################################################
# Copying new files                                                            #
################################################################################

output "Detecting previous Quake 2 installation..."
progress 10
sleep 3

grep "${APP_NAME}" $APIM_JSON_PATH
if [ $? -ne 0 ]; then
	output "Quake 2 not detected. Adding JSON entry for Apps Launcher..." 1
	progress 25
	mkdir -p $APIM_APPS_PATH/$APP_AUTHOR/$APP_FOLDER
	sed -i 's#]#,{"appName":"'"${APP_NAME}"'", "appFile":"'"${APP_AUTHOR}"'/'"${APP_FOLDER}"'/'"${APP_FILE}"'", "appIcon":"'"${APP_AUTHOR}"'/'"${APP_FOLDER}"'/Icon", "appHideTitle":'${APP_HIDETITLE}'}]#g' $APIM_JSON_PATH
	sleep 2

	output "Quake 2 not detected. Adding startup entry..."
	progress 35
	echo "/fs/mp/scripts/quake2_launcher.sh &" >> /fs/mp/scripts/startup_gf.sh
	sleep 2
else
	output "Previous Quake 2 installation detected."
	progress 35
	sleep 2

	progress 40
	if [ ${KEEP_SAVED_GAMES} -eq 1 ]; then
		output "Backup save game files..."

		rm -rf ${BACKUP_FOLDER}
		mkdir -p ${BACKUP_FOLDER}
		mv ${INSTALLATION_FOLDER}/baseq2/save ${BACKUP_FOLDER}/
	fi
	sleep 3
fi

progress 50
output "Installing Quake 2 Launcher files..."
cp ${SHELL_DIR}/quake2_launcher.sh /fs/mp/scripts
cp -R ${LOCAL_APP_PATH}/* $APIM_APPS_PATH/$APP_AUTHOR/$APP_FOLDER
chmod +x /fs/mp/scripts/quake2_launcher.sh
sleep 3

progress 70
output "Installing Quake 2 game files... please wait.. it might take a bit."
rm -rf ${INSTALLATION_DIR}
mkdir -p ${INSTALLATION_DIR}
cp -r ${MOD_DATA_DIR}/* ${INSTALLATION_DIR}/

progress 80
output "Configuring files permissions..."
chmod +x ${INSTALLATION_DIR}/my-hid
chmod +x ${INSTALLATION_DIR}/quake2-gles2
chmod +x ${INSTALLATION_DIR}/quake2_start.sh
sleep 1

progress 85
if [ -d ${BACKUP_FOLDER}/save ]; then
	echo "Restore saved games..." > $DISPLAY

	mv ${BACKUP_FOLDER}/save ${INSTALLATION_FOLDER}/baseq2
	rm -rf ${BACKUP_FOLDER}
	sleep 3
fi

###############################################################################
# Remount FS as RW                                                            #
###############################################################################

progress 95
output "Setting RO permissions to FS..." 1
. /fs/rwdata/dev/remount_ro.sh
sync
sync
sync

###############################################################################
# Display success image and reboot                                            #
###############################################################################

progress 100
output "Installation completed. Please remove the USB stick to reboot."
installationTerminated