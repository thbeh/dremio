FROM centos:7
MAINTAINER pgtdev@polyglotted.io

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Polyglotted Dremio" \
      org.label-schema.description="Polyglotted Dremio docker image" \
      org.label-schema.url="http://polyglotted.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/polyglotted/dremio" \
      org.label-schema.vendor="Polyglotted Limited" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV JAVA_VERSION=8 \
    JAVA_UPDATE=151 \
    JAVA_BUILD=12 \
    JAVA_PATH=e758a0de34e24606bca991d704f6dcbf \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ENV DREM_VER_MAJOR 1.2.2
ENV DREM_VER_MINOR 201710100154510864
ENV DREM_VER_BUILD d40e31c
ENV DREM_VER ${DREM_VER_MAJOR}-${DREM_VER_MINOR}-${DREM_VER_BUILD}

RUN yum -y install wget ca-certificates tar unzip && \
    cd "/tmp" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    tar -xzf "jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    mkdir -p "/usr/lib/jvm" && \
    mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    rm -rf "$JAVA_HOME/"*src.zip && \
    rm -rf "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/plugin.jar" \
           "$JAVA_HOME/jre/lib/ext/jfxrt.jar" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/"*jfx* \
           "$JAVA_HOME/jre/lib/amd64/libdecora_sse.so" \
           "$JAVA_HOME/jre/lib/amd64/"libprism_*.so \
           "$JAVA_HOME/jre/lib/amd64/libfxplugins.so" \
           "$JAVA_HOME/jre/lib/amd64/libglass.so" \
           "$JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so" \
           "$JAVA_HOME/jre/lib/amd64/"libjavafx*.so \
           "$JAVA_HOME/jre/lib/amd64/"libjfx*.so && \
    rm -rf "$JAVA_HOME/jre/bin/jjs" \
           "$JAVA_HOME/jre/bin/keytool" \
           "$JAVA_HOME/jre/bin/orbd" \
           "$JAVA_HOME/jre/bin/pack200" \
           "$JAVA_HOME/jre/bin/policytool" \
           "$JAVA_HOME/jre/bin/rmid" \
           "$JAVA_HOME/jre/bin/rmiregistry" \
           "$JAVA_HOME/jre/bin/servertool" \
           "$JAVA_HOME/jre/bin/tnameserv" \
           "$JAVA_HOME/jre/bin/unpack200" \
           "$JAVA_HOME/jre/lib/ext/nashorn.jar" \
           "$JAVA_HOME/jre/lib/jfr.jar" \
           "$JAVA_HOME/jre/lib/jfr" \
           "$JAVA_HOME/jre/lib/oblique-fonts" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/jce_policy-${JAVA_VERSION}.zip" && \
    unzip -jo -d "${JAVA_HOME}/jre/lib/security" "jce_policy-${JAVA_VERSION}.zip" && \
    rm "${JAVA_HOME}/jre/lib/security/README.txt" && \
    rm "/tmp/"* && \
	mkdir -p /opt && \
	cd /opt && \
	wget http://download.dremio.com/community-server/${DREM_VER}/dremio-community-${DREM_VER}.tar.gz && \
	tar -xvzf dremio-community-${DREM_VER}.tar.gz && \
    rm -f dremio-community-${DREM_VER}.tar.gz && \
    mv dremio-community-${DREM_VER} dremio && \
    rm -rf /opt/dremio/jars/bundled

WORKDIR /opt/dremio

COPY dremio.conf /opt/dremio/conf/dremio.conf
COPY run.sh /opt/dremio/bin/run.sh
RUN chmod +x /opt/dremio/bin/run.sh

EXPOSE 9047
ENTRYPOINT ["/opt/dremio/bin/run.sh"]