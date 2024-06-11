#!/bin/bash
export DOCUMENTUM=/opt/documentum
export DOCUMENTUM_SHARED=/opt/documentum
export DATABASE_TYPE=Postgresql
export DM_HOME=$DM_HOME
export LC_ALL=C
export DATABASE_CONNECTION=$DM_DATABASE_NAME
export LD_LIBRARY_PATH=$DM_HOME/bin:"$LD_LIBRARY_PATH"
export JAVA_HOME=$JAVA_HOME
export POSTGRESQL_HOME=/usr
export JAVA_TOOL_OPTIONS="-Djava.locale.providers=COMPAT,SPI -Djdk.util.zip.disableZip64ExtraFieldValidation=true"
export CATALINA_OPTS="-Xms1024m -Xmx2024m"
export PATH=$DM_HOME/bin:$JAVA_HOME/bin:"$PATH"
export DM_DOCBASE_NAME=$DM_DOCBASE_NAME
export DM_DATABASE_NAME=$DM_DATABASE_NAME
export DM_DOCBASE_OWNER=$DM_DOCBASE_OWNER
export DM_DOCBASE_OWNER_PASSWORD=$DM_DOCBASE_OWNER_PASSWORD
export DM_APPSERVER_PORT=$DM_APPSERVER_PORT
export DM_DOCBROKER_EXT_CONFIG=$DM_DOCBROKER_EXT_CONFIG
export DM_DOCBROKER_NAME=$DM_DOCBROKER_NAME
export DM_DOCBROKER_EXT_NAME=$DM_DOCBROKER_EXT_NAME
export DM_DOCBROKER_EXT_HOST=$DM_DOCBROKER_EXT_HOST
export DM_DOCBROKER_EXT_PORT=$DM_DOCBROKER_EXT_PORT
export DM_DOCBROKER_EXT_IP=$DM_DOCBROKER_EXT_IP
export DM_PREFERENCES_PASSWORD=$DM_PREFERENCES_PASSWORD
export DM_PRESETS_PASSWORD=$DM_PRESETS_PASSWORD
