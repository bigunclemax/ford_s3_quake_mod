#!/bin/sh
FMODS_DATA_DIR=/fs/images/fmods_apps_data
INSTALLATION_DIR=${FMODS_DATA_DIR}/Quake2/

sed -i '/quake2_launcher\.sh/d' /fs/mp/scripts/startup_gf.sh
rm -f /fs/mp/scripts/quake2_launcher.sh
rm -fR ${INSTALLATION_DIR}