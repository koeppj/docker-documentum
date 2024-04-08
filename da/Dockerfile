FROM tomcat:9-jdk11-temurin-focal

ENV DM_DOCBROKER_HOST=documentum
ENV DM_DOCBROKER_PORT=1489
ENV DM_GR_REGISTRY_PASSWORD=123
ENV DM_GR_REGISTRY_USER=dm_bof_registry
ENV DM_GR_REGISTRY_REPO=sandbox
ENV DM_DA_PORT=8080
ENV DM_PREFERENCES_REPO=sandbox
ENV DM_PREFERENCES_PASSWORD=changeit
ENV DM_PRESETS_PASSWORD=changeit

# Copy and unzip the war file
COPY adds/da /usr/local/tomcat/webapps/da

# Location Documentum data dir
RUN mkdir /var/lib/documentum

# Other Files
# SCript to serve as new cmd
COPY scripts/cmd_da.sh /usr/local/tomcat/bin/cmd_da.sh
RUN chmod u+x /usr/local/tomcat/bin/cmd_da.sh

# Updated web.xml to turn of tag caching (required by WDK apps)
COPY adds/web.xml /usr/local/tomcat/conf/web.xml
# DFC props file to be updated by the startup script with container is started
COPY templates/dfc.properties /usr/local/tomcat/webapps/da/WEB-INF/classes/dfc.properties
# App.xml updated with placeholds to set container specific values for presets and 
# preferences settings.
COPY templates/app.xml /usr/local/tomcat/webapps/da/custom/app.xml
# Logging setup to change date format to ISO8601 and move log file location out of
# catalina work dir to /var/log/da.log (where it should be)
# TO-DO - Also redirect catalina logs to /var/log/
COPY adds/log4j2.properties /usr/local/tomcat/webapps/da/WEB-INF/classes/log4j2.properties

CMD [ "cmd_da.sh" ]

EXPOSE 8080