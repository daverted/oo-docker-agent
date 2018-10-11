####################################
#   Multi-stage build
#       1. build generator
#       2. build agent
####################################

# Stage 1 - Build Generator

FROM maven:3.5 as generator-builder

RUN git clone https://github.com/overops-samples/overops-event-generator.git /opt/overops-event-generator

RUN cd /opt/overops-event-generator \
    && mvn clean package -DskipTests=true


# Stage 2 - Build Agent

FROM timveil/oo-docker-base:alpine-glibc

LABEL maintainer="tjveil@gmail.com"

ARG COLLECTOR_HOST=collector
ARG COLLECTOR_PORT=6060
ARG MACHINE_NAME=agent-container

ENV TAKIPI_TMP_DIR=/tmp/takipi
ENV TAKIPI_AGENT_HOME=/opt/takipi

COPY --from=generator-builder /opt/overops-event-generator/target/overops-event-generator-*.jar .

RUN mkdir -pv $TAKIPI_TMP_DIR \
    && curl -fSL https://s3.amazonaws.com/app-takipi-com/deploy/linux/takipi-agent-latest.tar.gz -o /tmp/takipi-agent-latest.tar.gz \
    && tar -xvf /tmp/takipi-agent-latest.tar.gz -C $TAKIPI_TMP_DIR --strip-components=1 \
    && mv -v $TAKIPI_TMP_DIR /opt \
    && rm -rfv /tmp/takipi-agent-latest.tar.gz \
    && sed -i "s/\(takipi\.collector\.host=\).*\$/\1${COLLECTOR_HOST}/" $TAKIPI_AGENT_HOME/agent.properties \
    && sed -i "s/\(takipi\.collector\.port=\).*\$/\1${COLLECTOR_PORT}/" $TAKIPI_AGENT_HOME/agent.properties \
    && sed -i "s/\(takipi\.server\.name=\).*\$/\1${MACHINE_NAME}/" $TAKIPI_AGENT_HOME/agent.properties

# port for generator UI
EXPOSE 8080

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]