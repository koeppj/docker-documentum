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
# Setup Documentum Wetop webapp.
#
export WEBTOP_HOME=/usr/local/tomcat/webapps/webtop

#
# Only proceed if first time run
#
if [ ! -f /var/lib/webtopsetup ]; then
    #
    # Update the dfc.properties file
    #
    export DM_GR_REGISTRY_ENCRYPTED_PASSWORD=`java -cp $WEBTOP_HOME/WEB-INF/lib/dfc.jar com.documentum.fc.tools.RegistryPasswordUtils $DM_GR_REGISTRY_PASSWORD`
    rep_vars $WEBTOP_HOME/WEB-INF/classes/dfc.properties
    #
    # Now update app.xml for the preferences repo and password plus presets.  Assume presets uses global repo.
    #
    export DM_PREFERENCES_ENCRYPTED_PASSWORD=`java -cp "$WEBTOP_HOME/WEB-INF/classes:$WEBTOP_HOME/WEB-INF/lib/*" com.documentum.web.formext.session.TrustedAuthenticatorTool $DM_PREFERENCES_PASSWORD | cut -d '[' -f2 | cut -d ']' -f1`
    export DM_PRESETS_ENCRYPTED_PASSWORD=`java -cp "$WEBTOP_HOME/WEB-INF/classes:$WEBTOP_HOME/WEB-INF/lib/*" com.documentum.web.formext.session.TrustedAuthenticatorTool $DM_PRESETS_PASSWORD | cut -d '[' -f2 | cut -d ']' -f1`
    rep_vars $WEBTOP_HOME/custom/app.xml

    #
    # Update server.xml with correct hostname and serving port so online API 
    # tester works.
    sed -i s/localhost/${HOSTNAME}/g conf/server.xml
    sed -i s/8080/${DM_WEBTOP_PORT}/g conf/server.xml

    touch /var/lib/webtopsetup
fi

catalina.sh run