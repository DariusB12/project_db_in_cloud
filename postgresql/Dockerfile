FROM postgres:16

ENV POSTGRES_DB=no_temporal_extensions
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=dummy

COPY postgresql.conf /etc/postgresql/postgresql.conf

COPY bitemporal_schema.sql /docker-entrypoint-initdb.d/

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]