ARG BUILDKIT_INLINE_CACHE
ARG JAVA_BASE_IMAGE_VERSION
ARG ALPINE_BASE_IMAGE_VERSION

FROM amazoncorretto:${JAVA_BASE_IMAGE_VERSION}-alpine as jre-base
# required for strip-debug to work
ARG JAVA_MODULES
RUN apk add --no-cache binutils
RUN $JAVA_HOME/bin/jlink \
    --verbose \
    --add-modules ${JAVA_MODULES} \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /custom-jre

FROM alpine:${ALPINE_BASE_IMAGE_VERSION} as kafka-base
ARG KAFKA_HOME
ARG KAFKA_VERSION
ARG KAFKA_SCALA_VERSION
RUN apk add --no-cache --virtual=.build-dependencies curl ca-certificates && \
    mkdir -p "${KAFKA_HOME}" && \
    curl -sSL "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz" | tar -xzf - -C /tmp  && \
    mv -t "${KAFKA_HOME}/" \
          "/tmp/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}/bin" \
          "/tmp/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}/libs" \
          "/tmp/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}/config" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"*

FROM alpine:${ALPINE_BASE_IMAGE_VERSION}
ARG JAVA_HOME
ARG KAFKA_HOME
ARG KAFKA_VERSION
ARG KAFKA_USER
ARG KAFKA_USER_UID
ENV JAVA_HOME=${JAVA_HOME} \
    KAFKA_HOME=${KAFKA_HOME} \
    KAFKA_VERSION=${KAFKA_VERSION} \
    KAFKA_DATA_DIR_PATH=${KAFKA_HOME}/data/ \
    KAFKA_METADATA_DIR_PATH=${KAFKA_HOME}/metadata/ \
    PATH="${JAVA_HOME}/bin:${KAFKA_HOME}/bin:${PATH}"
RUN adduser --no-create-home -u ${KAFKA_USER_UID} -D ${KAFKA_USER} && \
    apk add --no-cache bash curl
COPY --from=jre-base /custom-jre ${JAVA_HOME}
COPY --from=kafka-base --chown=${KAFKA_USER} ${KAFKA_HOME} ${KAFKA_HOME}
WORKDIR ${KAFKA_HOME}
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
USER ${KAFKA_USER}
RUN bash -c "mkdir -p ${KAFKA_HOME}/{data,metadata,certs,auth}"
COPY --chown=${KAFKA_USER} ./config/ ${KAFKA_HOME}/config/
RUN touch ${KAFKA_HOME}/config/server.properties && \
    echo -e "\n" >> ${KAFKA_HOME}/config/server.properties && \
    echo "log.dir=${KAFKA_DATA_DIR_PATH}" >> ${KAFKA_HOME}/config/server.properties && \
    echo "metadata.log.dir=${KAFKA_METADATA_DIR_PATH}" >> ${KAFKA_HOME}/config/server.properties && \
    echo -e "\n" >> ${KAFKA_HOME}/config/server.properties
VOLUME ["${KAFKA_HOME}/data", "${KAFKA_HOME}/metadata"]
EXPOSE 9092
ENTRYPOINT ["/docker-entrypoint.sh"]
