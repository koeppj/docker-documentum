#!/bin/bash
function rep_vars() {
    for var in $(env | grep DM_); do
        var_name=`echo $var | cut -d'=' -f1`
        var_value=`echo $var | cut -d'=' -f2`
        var_value=$(echo $var_value | sed 's/\//\\\//g')
        sed -i s/\$$var_name/$var_value/g $1
    done
}
#
# Setup Documentum REST .
#
export REST_HOME=/usr/local/tomcat/webapps/dctm-rest

#
# Only proceed if first time run
#
if [ ! -f /var/lib/restsetup ]; then
    #
    # Update the dfc.properties file
    #
    export DM_GR_REGISTRY_ENCRYPTED_PASSWORD=`java -cp "$REST_HOME/WEB-INF/lib/*" com.documentum.fc.tools.RegistryPasswordUtils $DM_GR_REGISTRY_PASSWORD`
    rep_vars $REST_HOME/WEB-INF/classes/dfc.properties
    #
    # Update server.xml with correct hostname and serving port so online API 
    # tester works.
    sed -i s/localhost/${HOSTNAME}/g conf/server.xml
    sed -i s/8080/${DM_REST_PORT}/g conf/server.xml
    #
    # Do the same with the rest.yml in the web app
    #
    sed -i s/localhost:8080/${DM_REST_EXTERNAL_HOST}/g $REST_HOME/public/openapi/rest.yaml
    touch /var/lib/restsetup
fi

catalina.sh run