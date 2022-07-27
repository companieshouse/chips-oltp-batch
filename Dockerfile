FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-serverjre:1.2.1

ENV OLTP_HOME=/apps/oltp \
    ARTIFACTORY_BASE_URL=http://repository.aws.chdev.org:8081/artifactory

RUN yum -y install gettext && \
    yum -y install cronie && \
    yum -y install oracle-instantclient-release-el7 && \
    yum -y install oracle-instantclient-basic && \
    yum -y install oracle-instantclient-sqlplus && \
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install msmtp && \
#    yum -y install xmlstarlet && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN mkdir -p /apps && \
    chmod a+xr /apps && \
    useradd -d ${OLTP_HOME} -m -s /bin/bash oltp

USER oltp

# Copy all batch jobs to OLTP_HOME
COPY --chown=oltp oltp-batch ${OLTP_HOME}/

# Download the batch libs and set permission on scripts
RUN mkdir -p ${OLTP_HOME}/libs && \
    cd ${OLTP_HOME}/libs && \
#    curl ${ARTIFACTORY_BASE_URL}/virtual-release/log4j/log4j/1.2.14/log4j-1.2.14.jar -o log4j.jar && \
    chmod -R 750 ${OLTP_HOME}/*

WORKDIR $OLTP_HOME
USER root
CMD ["bash"]