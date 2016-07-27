# Openhab 1.8.3
# * configuration is injected
#
FROM java:openjdk-8-jdk
MAINTAINER Dawid Kuboszel <dk@fss.cc>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install unzip supervisor wget

RUN apt-get update && apt-get -y upgrade && apt-get -y install unzip supervisor wget

ENV OPENHAB_VERSION 1.8.3

#
# Download openHAB based on Environment OPENHAB_VERSION
#
COPY files/scripts/download_openhab.sh /root/
RUN /root/download_openhab.sh

COPY files/pipework /usr/local/bin/pipework
COPY files/supervisord.conf /etc/supervisor/supervisord.conf
COPY files/openhab.conf /etc/supervisor/conf.d/openhab.conf
COPY files/openhab_debug.conf /etc/supervisor/conf.d/openhab_debug.conf
COPY files/boot.sh /usr/local/bin/boot.sh
COPY files/openhab-restart /etc/network/if-up.d/openhab-restart

RUN mkdir -p /opt/openhab/logs

#
# Install HBAdmin
#
RUN /bin/bash -c 'wget --quiet --no-cookies -O /opt/openhab/addons/org.openhab.io.habmin-1.7.0.jar https://github.com/cdjackson/HABmin/raw/master/addons/org.openhab.io.habmin-1.7.0-SNAPSHOT.jar' && \
    /bin/bash -c 'wget --quiet --no-cookies -O /tmp/master.zip https://github.com/cdjackson/HABmin/archive/master.zip' && \
    unzip -q -d /tmp/habmin /tmp/master.zip && \
    mv /tmp/habmin/HABmin-master /opt/openhab/webapps/habmin

EXPOSE 8080 8443 5555 9001
VOLUME /etc/openhab
VOLUME /opt/openhab/addons
VOLUME /opt/openhab/addons-available

CMD ["/usr/local/bin/boot.sh"]
