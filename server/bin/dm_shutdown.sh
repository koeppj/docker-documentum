#!/bin/sh

echo "Gracefull shutdown..."
$DOCUMENTUM/tomcat9.0.58/bin/stopMethodServer.sh
$DOCUMENTUM/dba/dm_shutdown_$DM_DOCBASE_NAME
$DOCUMENTUM/dba/dm_stop_Docbroker
rm -r ~/running