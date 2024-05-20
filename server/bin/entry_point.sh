#!/bin/bash

# Catch SIGs so we can clean up
trap "echo TRAPed signal" HUP INT QUIT TERM

# CLear the the "running" flag so orchestration frameworks can monitor containing health
rm -f /var/lib/documentum/running

export DOCUMENTUM=/opt/documentum
export DM_HOME=$DOCUMENTUM/product/22.2
export JAVA_HOME=$DOCUMENTUM/javajdk
#
# First check if Service is updated.  If not first time in and we need to update a bunch
# of stuff for root.
# 
grep -q $DM_DOCBASE_PORT /etc/services
if  [ $? != 0 ]; then
    echo "$DM_DOCBASE_NAME          $DM_DOCBASE_PORT/tcp" >> /etc/services
    echo $DM_DOCBASE_NAME"_s        "$(($DM_DOCBASE_PORT + 1))/tcp  >> /etc/services
    envsubst < /home/dmadmin/templates/set_env.sh > /home/dmadmin/.env
    echo "Updated /etc/services..."
    mkdir /home/dmadmin/responses
    envsubst < /home/dmadmin/templates/config.properties > /home/dmadmin/responses/config.properties
    envsubst < /home/dmadmin/templates/ts_config.properties > /home/dmadmin/responses/ts_config.properties
    envsubst < /home/dmadmin/templates/ts_install.properties > /home/dmadmin/responses/ts_install.properties
    envsubst < /home/dmadmin/templates/odbc.ini > /etc/odbc.ini
    echo ". ~/.env" >> /home/dmadmin/.bashrc
    echo "Templates Processed"
fi

# The rest should be run as dmadin
su - -c '~/bin/dm_entry.sh' dmadmin

#
# If not running just hang out in unhealthy state so somecan can look at the logs.  
# One docker sends a SIGINT exit the script and container stops.
#
if [ ! -f /var/lib/documentum/running ]; then
    echo Problem occured installing, configuring or starting...
    echo Server not in healthy state!
    read
fi

#
# Tail the log file until SIGINT is received
#
tail -f $DOCUMENTUM/dba/log/$DM_DOCBASE_NAME.log

#
# Shutdown gracefully
#
su -c '/home/dmadmin/bin/dm_shutdown.sh' dmadmin

echo "Exited conntent server container..."

