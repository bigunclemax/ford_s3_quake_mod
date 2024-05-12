#!/bin/sh
filePath="/fs/images/fmods_apps_data/Quake2/launcher"
echo "standby" > $filePath

while true; do
	grep -q "launch" $filePath
	if [ $? -eq 0 ]; then
		/fs/images/fmods_apps_data/Quake2/quake2_start.sh
		echo "standby" > $filePath
	fi
	sleep 0.5
done
