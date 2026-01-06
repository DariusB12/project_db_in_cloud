FROM mysql:8.4

ENV MYSQL_DATABASE=no_temporal_extensions
ENV MYSQL_ROOT_PASSWORD=dummy

COPY my.cnf /etc/mysql/conf.d/my.cnf

COPY bitemporal_schema.sql /docker-entrypoint-initdb.d/