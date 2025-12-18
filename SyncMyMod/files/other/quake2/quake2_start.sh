#!/bin/sh

BASEDIR=$(dirname "$0")
HIDD_BIN=${BASEDIR}/my-hid
HIDD_LIB_NAME=devh-usb.so

# Check if HID server already running
ps -A | grep -q my-hid
if [ $? -ne 0 ]; then
	cp ${BASEDIR}/${HIDD_LIB_NAME} /tmp/
	${HIDD_BIN} -d /tmp/${HIDD_LIB_NAME}

	# Sometimes, for unknown reasons, io-hid fails to detect HID
	# devices until hidview is called.
	# This issue was observed with my PS4 controller.
	# The workaround is to run hidview first to "activate"
	# the HID subsystem.
	hidview -N /dev/io-hid/my-hid
fi

GAME=""
if [ $# -ne 0 ]; then
	GAME="$1"
fi

case "$GAME" in
	"xatrix" | "rogue" | "zaero")
		GAME_OPT="+set game $GAME"
		;;
	*)
		GAME_OPT=""
		;;
esac

export SDL_AUDIO_DEVICE_NAME="MCBSP @ 49026000 d1" #BT audio dev C1D1p

(cd ${BASEDIR}; ./quake2-gles2 $GAME_OPT)

