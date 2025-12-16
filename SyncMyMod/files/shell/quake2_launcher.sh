#!/bin/sh
filePath="/fs/images/fmods_apps_data/Quake2/launcher"
filePath1="/fs/images/fmods_apps_data/Quake2/launcher1"
filePath2="/fs/images/fmods_apps_data/Quake2/launcher2"
filePath3="/fs/images/fmods_apps_data/Quake2/launcher3"
echo "standby" > $filePath
echo "standby" > $filePath1
echo "standby" > $filePath2
echo "standby" > $filePath3

while true; do
	grep -q "launch" $filePath
	if [ $? -eq 0 ]; then
		/fs/images/fmods_apps_data/Quake2/quake2_start.sh
		echo "standby" > $filePath
	fi
	sleep 0.2
	grep -q "launch1" $filePath1
	if [ $? -eq 0 ]; then
		/fs/images/fmods_apps_data/Quake2/quake2_xatrix_start.sh
		echo "standby" > $filePath1
	fi
	sleep 0.2
	grep -q "launch2" $filePath2
	if [ $? -eq 0 ]; then
		/fs/images/fmods_apps_data/Quake2/quake2_rogue_start.sh
		echo "standby" > $filePath2
	fi
	sleep 0.2
	grep -q "launch3" $filePath3
	if [ $? -eq 0 ]; then
		/fs/images/fmods_apps_data/Quake2/quake2_zaero_start.sh
		echo "standby" > $filePath3
	fi
	sleep 0.5
done

