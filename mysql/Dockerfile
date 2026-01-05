# Folosim imaginea oficială de MySQL
FROM mysql:8.0

# Setăm variabilele de mediu (opțional aici, pot fi puse și în docker-compose)
ENV MYSQL_DATABASE=no_temporal_extensions
ENV MYSQL_ROOT_PASSWORD= 

# Copiem schema.sql în folderul de inițializare
# Toate scripturile din acest folder sunt rulate la prima pornire
COPY bitemporal_schema.sql /docker-entrypoint-initdb.d/