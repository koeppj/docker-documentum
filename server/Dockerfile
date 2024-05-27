FROM ubuntu:focal

# Filenames of the compressed distros for Content Server, Thumbnail Server
# and OpenJDK
ARG DM_CS_DISTRO_FILENAME=documentum_server_22.2_linux64_postgres.tar
ARG DM_TS_DISTRO_FILENAME=thumbnailserver_linux_22.2.tar
ARG DM_JDK_DISTRO_FILENAME=openlogic-openjdk-11.0.22+7-linux-x64.tar

ENV DM_DOCBROKER_PORT=1489
ENV DM_DOCBASE_PORT=50100
ENV DM_DOCBASE_NAME=sandbox
ENV DM_DOCBASE_OWNER=sandbox
ENV DM_DOCBASE_OWNER_PASSWORD=changeme
ENV DM_DOCBASE_ID=42910
ENV DM_DOCBASE_DESC=Sandbox_Docbase
ENV DM_SMTP_SERVER_NAME=mail.koeppster.address
ENV DM_SMTP_EMAIL_ACCOUNT=koeppj@koeppster.net
ENV DM_DATABASE_HOST=postgres
ENV DM_DATABASE_PORT=5432
ENV DM_DATABASE_ADMIN_NAME=postgres
ENV DM_DATABASE_ADMIN_PASSWORD=changeme
ENV DM_DATABASE_PASSWORD=changeme
ENV DM_DATABASE_NAME=sandbox
ENV DM_DATABASE_OWNER=sandbox
ENV DM_DATABASE_OWNER_PASSWORD=changeme
ENV DM_APPSERVER_PORT=9080
ENV DM_SERVER_HOST=documentum
ENV DM_GR_REGISTRY_PASSWORD=123
ENV DM_GR_REGISTRY_USER=dm_bof_registry
ENV DM_GR_REGISTRY_REPO=sandbox
ENV DM_PREFERENCES_PASSWORD=changeit
ENV DM_PRESETS_PASSWORD=changeit
ENV DM_TS_PORT=8081
ENV DM_TS_ADMIN_PORT=8080
ARG DEBIAN_FRONTEND=noninteractive

# Required Packages
RUN apt update
RUN apt -y install tzdata
RUN apt -y install postgresql-client-12
RUN apt -y install unixodbc unixodbc-dev odbc-postgresql csh
RUN apt -y install tcl tcl-expect gettext iproute2

RUN adduser dmadmin --disabled-password 

# Documentum Directories and Volumes
RUN mkdir -p /opt/documentum
RUN mkdir -p /opt/documentum/dfcdata
RUN chown -R dmadmin:dmadmin /opt/documentum
RUN mkdir -p /var/lib/documentum
RUN chown dmadmin:dmadmin /var/lib/documentum


# OpenJDK goes here.  Note JDKs .tars generally distributed with the first level
# being a directory.  We strip that level so that JAVA_HOME is always $DOCUMENTUM/javajdk
COPY adds/${DM_JDK_DISTRO_FILENAME} /opt/documentum/${DM_JDK_DISTRO_FILENAME}
RUN mkdir /opt/documentum/javajdk
RUN tar -xf /opt/documentum/${DM_JDK_DISTRO_FILENAME} -C /opt/documentum/javajdk --strip-components=1
RUN rm /opt/documentum/${DM_JDK_DISTRO_FILENAME}
RUN chown -R dmadmin:dmadmin /opt/documentum/javajdk

# Content Server and Thumbnail Installers, Templates and Scripts
ADD --chown=dmadmin:dmadmin adds/${DM_CS_DISTRO_FILENAME} /home/dmadmin/installer/
ADD --chown=dmadmin:dmadmin adds/${DM_TS_DISTRO_FILENAME} /home/dmadmin/thumbnailserver/

# Templates and Container Scripts
COPY --chown=dmadmin:dmadmin templates /home/dmadmin/templates
COPY --chown=dmadmin:dmadmin bin /home/dmadmin/bin
RUN chmod u+x /home/dmadmin/bin/*

# Set up ports well known ports
EXPOSE 1489 1490 50100 50101 9080

USER dmadmin
WORKDIR /home/dmadmin/installer
RUN /home/dmadmin/bin/dm_install.sh

WORKDIR /opt/documentum
RUN tar -cf dba.tar dba
RUN sed -i 's#/opt/documentum#/opt/documentum/dfcdata#g' config/dfc.properties
RUN tar -cf config.tar config

USER root
WORKDIR /

# Data and Share Volumes
VOLUME [ "/var/lib/documentum", "/opt/documentum/dba", "/opt/documentum/config", "/opt/documentum/presets", "/opt/documentum/dfcdata" ]

CMD [ "/home/dmadmin/bin/entry_point.sh" ]
