FROM tomcat:9-jdk11-temurin-focal

ENV DM_DOCBROKER_HOST=documentum
ENV DM_DOCBROKER_PORT=1489
ENV DM_GR_REGISTRY_PASSWORD=123
ENV DM_GR_REGISTRY_USER=dm_bof_registry
ENV DM_GR_REGISTRY_REPO=sandbox
ENV DM_REST_PORT=8080

# Copy and unzip the war file
COPY adds/dctm-rest /usr/local/tomcat/webapps/dctm-rest

# Location Documentum data dir
RUN mkdir /var/lib/documentum

# Other Files
# SCript to serve as new cmd
COPY scripts/cmd_rest.sh /usr/local/tomcat/bin/cmd_rest.sh
RUN chmod u+x /usr/local/tomcat/bin/cmd_rest.sh

# DFC props file to be updated by the startup script with container is started
COPY templates/dfc.properties /usr/local/tomcat/webapps/dctm-rest/WEB-INF/classes/dfc.properties
# Logging setup to change date format to ISO8601 and move log file location out of
# catalina work dir to /var/log/da.log (where it should be)
# TO-DO - Also redirect catalina logs to /var/log/
COPY adds/log4j2.properties /usr/local/tomcat/webapps/dctm-rest/WEB-INF/classes/log4j2.properties

CMD [ "cmd_rest.sh" ]

EXPOSE 8080