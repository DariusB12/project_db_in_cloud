FROM postgres:15

# Setăm baza de date implicită
ENV POSTGRES_DB=no_temporal_extensions
ENV POSTGRES_PASSWORD= 

# Copiem schema în folderul de inițializare
COPY bitemporal_schema.sql /docker-entrypoint-initdb.d/