#!/bin/sh

BASEDIR=$(dirname "$0")
HIDD_BIN=${BASEDIR}/my-hid
HIDD_LIB_NAME=devh-usb.so

# Check if HID server already running
ps -A | grep -q my-hid
if [ $? -ne 0 ]; then
	cp ${BASEDIR}/${HIDD_LIB_NAME} /tmp/
	${HIDD_BIN} -d /tmp/${HIDD_LIB_NAME}
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

(cd ${BASEDIR}; ./quake2-gles2 $GAME_OPT)

