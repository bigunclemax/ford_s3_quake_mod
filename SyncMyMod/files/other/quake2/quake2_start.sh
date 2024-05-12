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

(cd ${BASEDIR}; ./quake2-gles2)

