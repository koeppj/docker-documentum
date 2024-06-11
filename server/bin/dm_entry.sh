#!/bin/bash
. ~/.env

#
# Check software installation Status.  If not installed then install it.
# 
#if [ ! -f /var/lib/documentum/server_installed ]; then
#    cd ~/installer
#    echo Installing Server...
#    ./serverSetup.bin -f ~/responses/install.properties
#    if [ $? != 0 ]; then
#        echo Installation Failed!!!
#        cat logs/install.log
#        exit
#    fi
#    touch /var/lib/documentum/server_installed
#fi

#
# Wait for the DB to be available using dmdbtest
# TODO - Fix to work when docebase owner it now initially present (very uncommon)
#
dmdbtest -D$DM_DATABASE_NAME -S$DM_DATABASE_NAME -U$DM_DOCBASE_OWNER -P$DM_DOCBASE_OWNER_PASSWORD -Mconnect
until [ $? = 0 ]; do
    echo "Waiting 30 seconds for Database to come up"
    sleep 30s
    dmdbtest -D$DM_DATABASE_NAME -S$DM_DATABASE_NAME -U$DM_DOCBASE_OWNER -P$DM_DOCBASE_OWNER_PASSWORD -Mconnect
done

#
# Database is up.  Now run configuration if not done previously
#
if [ ! -f /opt/documentum/dba/server_configured ]; then
    echo "Unpacking the dba and config folder tarballs created during image build..."
    tar -xf /opt/documentum/dba.tar -C /opt/documentum --overwrite
    tar -xf /opt/documentum/config.tar -C /opt/documentum --overwrite
    cd $DM_HOME/install
    echo Configuring Server...
    ./dm_launch_server_config_program.sh -f ~/responses/config.properties
    if [ $? != 0 ]; then 
        echo Configuration Failed!!!
        cat logs/install.log
        exit
    fi
    echo Updating docbase owner user object
    envsubst < ~/templates/update_docbase_owner.dql | idql $DM_DOCBASE_NAME -Udmadmin 
    echo Updating log4j configurations to use ISO8601 date formatting...
    for LOG_FILE in `find $DOCUMENTUM -name log4j2.properties`; do
        sed -i 's/ABSOLUTE/ISO8601/g' $LOG_FILE
    done
    # 
    # Add the IPV4 only flag to server.ini
    # 
    echo Updateing server.ini
    awk -v section="[SERVER_STARTUP]" -v line="ip_mode = V4ONLY" -f ~/bin/addline.awk \
        $DOCUMENTUM/dba/config/sandbox/server.ini > tmpini & mv tmpini $DOCUMENTUM/dba/config/sandbox/server.ini
    #
    # If secified add the "external" docbroker for DFC clients external to the container network
    #
    if [[ -n "${DM_DOCBROKER_EXT_CONFIG}" ]]; then
        ./dm_launch_server_config_program.sh -f ~/responses/ext_broker.properties
        $DOCUMENTUM/dba/dm_stop_$DM_DOCBROKER_EXT_NAME
        #
        # Set up the IP translation for the gateway IP
        #
        cat <<EOF >> $DOCUMENTUM/dba/$DM_DOCBROKER_EXT_NAME.ini
[TRANSLATION]
host=$DM_DOCBROKER_EXT_IP=$(hostname -I)
EOF
        #
        # Make sure docbase projects with the external docbrocker service
        #
        cat <<EOF >> $DOCUMENTUM/dba/config/$DM_DOCBASE_NAME/server.ini
[DOCBROKER_PROJECTION_TARGET_2]
host = $DM_DOCBROKER_EXT_HOST
port = $DM_DOCBROKER_EXT_PORT
EOF
    fi
    touch /opt/documentum/dba/server_configured
    #
    # Shutdown everything else a freshstart
    #
    $DOCUMENTUM/dba/dm_shutdown_$DM_DOCBASE_NAME
    $DOCUMENTUM/dba/dm_stop_$DM_DOCBROKER_NAME

fi

#
# If here install complete, db is up and config completed.  Start docbroker and docbase if not already 
# running and then wait for it to be up before tailing the log.
#
$DOCUMENTUM/dba/dm_launch_$DM_DOCBROKER_NAME
if [[ -n "${DM_DOCBROKER_EXT_CONFIG}" ]]; then
    $DOCUMENTUM/dba/dm_launch_$DM_DOCBROKER_EXT_NAME
fi

~/bin/dm_health_check.sh
if [ $? != 0 ]; then
    echo "Staring Repo..."
    $DOCUMENTUM/dba/dm_start_$DM_DOCBASE_NAME
fi
~/bin/dm_health_check.sh
until [ $? = 0 ]; do
    echo "Waiting 30 seconds for Database to come up..."
    sleep 30s
    ~/bin/dm_health_check.sh
done

#
# Check to see if the JMS is running and start if needed
#
if [ "$($DOCUMENTUM/tomcat9.0.58/bin/dctmServerStatus.sh $DM_APPSERVER_PORT)" != "Tomcat Server is running" ]; then
    echo "Starting Method Server..."
    $DOCUMENTUM/tomcat9.0.58/bin/startMethodServer.sh
fi
until [ "$($DOCUMENTUM/tomcat9.0.58/bin/dctmServerStatus.sh $DM_APPSERVER_PORT)" = "Tomcat Server is running" ]; do
    echo "Waiting 30 seconds for method server to start..."
    sleep 30s
done

#
# And we are up - Set the health tag and exit to caller
#
touch /opt/documentum/dba/running