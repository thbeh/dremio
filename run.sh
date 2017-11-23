#!/bin/sh

java -Djava.util.logging.config.class=org.slf4j.bridge.SLF4JBridgeHandler -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:MaxDirectMemorySize=8192m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/dremio/logs -Xms4096m -Xmx4096m -cp /opt/dremio/conf:/opt/dremio/jars/*:/opt/dremio/jars/ext/*:/opt/dremio/jars/3rdparty/* com.dremio.dac.daemon.DremioDaemon dremio start