#!/bin/bash
cd /home/dmadmin/installer
export DOCUMENTUM=/opt/documentum
export DM_HOME=$DOCUMENTUM/product/22.2
export JAVA_HOME=$DOCUMENTUM/javajdk
export LAX_VM=$JAVA_HOME/bin/java
export DOCUMENTUM_SHARED=/opt/documentum
export DATABASE_TYPE=Postgresql
export LC_ALL=C
export LD_LIBRARY_PATH=$DM_HOME/bin:"$LD_LIBRARY_PATH"
export POSTGRESQL_HOME=/usr
export PATH=$JAVA_HOME/bin:"$PATH"
export JAVA_TOOL_OPTIONS="-Djava.locale.providers=COMPAT,SPI -Djdk.util.zip.disableZip64ExtraFieldValidation=true"
/home/dmadmin/installer/serverSetup.bin -f /home/dmadmin/templates/install.properties