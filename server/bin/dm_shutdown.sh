#!/bin/sh
. ~/.env
echo "Gracefull shutdown..."
$DOCUMENTUM/tomcat9.0.58/bin/stopMethodServer.sh
$DOCUMENTUM/dba/dm_shutdown_$DM_DOCBASE_NAME
$DOCUMENTUM/dba/dm_stop_$DM_DOCBROKER_NAME
if [[ -n "${DM_DOCBROKER_EXT_CONFIG}" ]]; then
    $DOCUMENTUM/dba/dm_stop_$DM_DOCBROKER_EXT_NAME
fi
rm -r /opt/documentum/dba/running