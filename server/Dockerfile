FROM ubuntu:focal

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
ARG DEBIAN_FRONTEND=noninteractive

# Required Packages
RUN apt update
RUN apt -y install tzdata
RUN apt -y install postgresql-client-12
RUN apt -y install unixodbc unixodbc-dev odbc-postgresql csh
RUN apt -y install tcl-expect gettext iproute2

RUN adduser dmadmin --disabled-password 

# Documentum Directories and Volumes
RUN mkdir /opt/documentum
RUN chown dmadmin:dmadmin /opt/documentum
RUN mkdir /var/lib/documentum
RUN chown dmadmin:dmadmin /var/lib/documentum

# Data and Share Volumes
VOLUME [ "/var/lib/documentum" ]

# OpenJDK goes here
COPY --chown=dmadmin:dmamin openlogic-openjdk-11.0.22+7-linux-x64 /opt/documentum/openlogic-openjdk-11.0.22+7-linux-x64

## Installers, Templates and Scripts
COPY --chown=dmadmin:dmadmin installer /home/dmadmin/installer
COPY --chown=dmadmin:dmadmin templates /home/dmadmin/templates
COPY --chown=dmadmin:dmadmin bin /home/dmadmin/bin
RUN chmod u+x /home/dmadmin/bin/*

# Set up ports will known ports
EXPOSE 1489 1490 50100 50101 9080

ENTRYPOINT [ "/home/dmadmin/bin/entry_point.sh" ]
