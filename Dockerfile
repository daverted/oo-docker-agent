FROM timveil/oo-docker-base:alpine-musl

LABEL maintainer="tjveil@gmail.com"

ARG COLLECTOR_HOST=collector
ARG COLLECTOR_PORT=6060
ARG MACHINE_NAME=agent-container

ENV TAKIPI_TMP_DIR=/tmp/takipi
ENV TAKIPI_AGENT_HOME=/opt/takipi

RUN curl \
        -o overops-event-generator.jar \
        -L https://s3-us-west-1.amazonaws.com/overops/overops-event-generator-1.2.1.jar

RUN mkdir -pv $TAKIPI_TMP_DIR \
    && curl -fSL https://s3.amazonaws.com/app-takipi-com/deploy/linux/takipi-agent-latest.tar.gz -o /tmp/takipi-agent-latest.tar.gz \
    && tar -xvf /tmp/takipi-agent-latest.tar.gz -C $TAKIPI_TMP_DIR --strip-components=1 \
    && mv -v $TAKIPI_TMP_DIR /opt \
    && rm -rfv /tmp/takipi-agent-latest.tar.gz \
    && sed -i "s/\(takipi\.collector\.host=\).*\$/\1${COLLECTOR_HOST}/" $TAKIPI_AGENT_HOME/agent.properties \
    && sed -i "s/\(takipi\.collector\.port=\).*\$/\1${COLLECTOR_PORT}/" $TAKIPI_AGENT_HOME/agent.properties \
    && sed -i "s/\(takipi\.server\.name=\).*\$/\1${MACHINE_NAME}/" $TAKIPI_AGENT_HOME/agent.properties

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]