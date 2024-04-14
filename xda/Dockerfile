FROM eclipse-temurin:11-jre-alpine 

ENV DM_DOCBROKER_HOST="documentum"
ENV DM_DOCBROKER_PORT="1489"
ENV DM_DOCBASE_NAME="sandbox"
ENV DM_GR_REGISTRY_REPO="sandbox"
ENV DM_GR_REGISTRY_USER="dm_bof_registry"
ENV DM_GR_REGISTRY_PASSWORD="123"
ENV DM_XDA_PORT="7000"
ENV BUILD_DEPS="gettext" RUNTIME_DEPS="libintl"

ARG DM_XDA_DISTRO_NAME="xda_linux64_22.2.tar"

# Basex scripts need bash (:
RUN apk add --no-cache bash

# Copy the disto
ADD adds/${DM_XDA_DISTRO_NAME} /opt/

# Persistent VOlume Locations
# First the DFC
RUN mkdir -p /var/lib/xDa/documentum
# xDA Data
RUN mkdir -p /var/lib/xDA/data

# Copy the templates and scripts
COPY templates/* /opt/xDA/config/.
COPY scripts/cmd_xda.sh /

VOLUME [ "/var/lib/xDA/documentum", "/var/lib/xDA/data" ]

CMD [ "./cmd_xda.sh"]
