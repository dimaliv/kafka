#!/bin/bash

set -e

_KAFKA_SERVER_START_OVERRIDES=""
_KAFKA_CLUSTER_ID=""
_KAFKA_LOG_LEVEL=""
_KAFKA_LOG_LEVEL_DEFAULT_VALUE="INFO"

for LOOP_ARG in "$@"
do
    if [[ "$LOOP_ARG" =~ "--custom-set log.level=" ]]; then
       _KAFKA_LOG_LEVEL="${LOOP_ARG#*=}"
    fi;

    if [[ "$LOOP_ARG" =~ "--override " ]]; then
        _KAFKA_SERVER_START_OVERRIDES="$_KAFKA_SERVER_START_OVERRIDES $LOOP_ARG"
        echo "${LOOP_ARG#* }" >> ${KAFKA_HOME}/config/server.properties
    fi;

    if [[ "$LOOP_ARG" =~ "--override kraft.cluster.id=" ]]; then
        _KAFKA_CLUSTER_ID="${LOOP_ARG#*=}"
    fi;
done

if [[ "_$_KAFKA_CLUSTER_ID" != "_" ]]; then
    ${KAFKA_HOME}/bin/kafka-storage.sh format --cluster-id=${_KAFKA_CLUSTER_ID} --ignore-formatted --config ${KAFKA_HOME}/config/server.properties
else
    echo "You should define kraft.cluster.id value."
    exit 1;
fi;

if [[ "_$_KAFKA_LOG_LEVEL" == "_" ]]; then
    _KAFKA_LOG_LEVEL="${_KAFKA_LOG_LEVEL_DEFAULT_VALUE}"
else
    if [[ ",ALL,DEBUG,INFO,WARN,ERROR,FATAL,OFF,TRACE," =~ ",${_KAFKA_LOG_LEVEL}," ]]; then
        echo "Log level: ${_KAFKA_LOG_LEVEL}"
    else
        echo "Unknown log level: ${_KAFKA_LOG_LEVEL}"
        _KAFKA_LOG_LEVEL="${_KAFKA_LOG_LEVEL_DEFAULT_VALUE}"
        echo "Set default log level: ${_KAFKA_LOG_LEVEL}"
    fi;
fi;

echo "" >> ${KAFKA_HOME}/config/log4j.properties
echo "log4j.rootLogger=${_KAFKA_LOG_LEVEL},stdout" >> ${KAFKA_HOME}/config/log4j.properties
echo "" >> ${KAFKA_HOME}/config/log4j.properties

exec "${KAFKA_HOME}/bin/kafka-server-start.sh" "${KAFKA_HOME}/config/server.properties" $_KAFKA_SERVER_START_OVERRIDES
