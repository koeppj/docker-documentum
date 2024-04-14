#/bin/sh

DM_XDA_HOME=/opt/xDA
DM_XDA_VAR=/var/lib/xDA

function rep_vars() {
    for var in $(env | grep DM_); do
        var_name=`echo $var | cut -d'=' -f1`
        var_value=`echo $var | cut -d'=' -f2`
        var_value=$(echo $var_value | sed 's/\//\\\//g')
        sed -i s/\$$var_name/$var_value/g $1
    done
}

if [ ! -f $DM_XDA_VAR/configured ]; then
    unzip $DM_XDA_HOME/xda.war "WEB-INF/lib/*" -j -d /tmp/xda
    export DM_GR_REGISTRY_ENCRYPTED_PASSWORD=`java -cp "/tmp/xda/*" com.documentum.fc.tools.RegistryPasswordUtils $DM_GR_REGISTRY_PASSWORD`
    rep_vars $DM_XDA_HOME/config/dfc.properties    
    rep_vars $DM_XDA_HOME/config/xda-config.properties 
    touch $DM_XDA_VAR/configured
fi

$DM_XDA_HOME/bin/xda.sh
