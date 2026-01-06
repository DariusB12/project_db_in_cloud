FROM quay.io/debezium/connect:3.0

USER root

RUN mkdir -p /kafka/connect/debezium-connector-jdbc && \
    cd /kafka/connect/debezium-connector-jdbc && \
    curl -L -o debezium-connector-jdbc.tar.gz \
    https://repo1.maven.org/maven2/io/debezium/debezium-connector-jdbc/3.0.0.Final/debezium-connector-jdbc-3.0.0.Final-plugin.tar.gz && \
    tar -xzf debezium-connector-jdbc.tar.gz --strip-components=1 && \
    rm debezium-connector-jdbc.tar.gz

USER kafka
