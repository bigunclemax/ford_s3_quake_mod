#!/bin/sh
filePath="/fs/images/fmods_apps_data/Quake2/launcher"
echo "standby" > $filePath

while true; do
	grep -q "launch" $filePath
	if [ $? -eq 0 ]; then
		GAME=$(cat $filePath | awk -F'-' '{print $2}')
		/fs/images/fmods_apps_data/Quake2/quake2_start.sh "$GAME"
		echo "standby" > $filePath
	fi
	sleep 0.5
done

