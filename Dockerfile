FROM ubuntu:16.04
MAINTAINER DevsecOps Juan Camilo M

# Anadimos la clave PGP de PostgreSQL para verificación.
# Deberia coincidir con https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Agregamos el repositorio de PostgreSQL.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Actualizacion de los repositorios de ubuntu
# Debemos instalar ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
RUN apt-get update \
    && apt-get install -y python-software-properties \
       software-properties-common \
       postgresql-9.3 \
       postgresql-client-9.3 \
       postgresql-contrib-9.3 

# Nos cambiamos a usuario root
USER root

# Copias el archivo entrypoint.sh y le damos permiso
ADD entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

# Usamos el usuario ``postgres``, que se ha creado con la instalacion.
USER postgres

# Crearemos un usuario con el nombre ``docker`` con password ``docker``
# creamos la base de datos llamada ``docker`` 
RUN  /etc/init.d/postgresql start && \
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" \
    && createdb -O docker docker

# Permitimos conexiones de clientes remotos a PostgreSQL.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# Permitimos que se pueda acceder por cualquier ip que tenga el contenedor
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Exponemos el puerto de la base de datos
EXPOSE 5432

# Agregamos volumenes para backup, logs y base de datos
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

##Ejecutamos el script entrypoint.sh
CMD /usr/local/bin/entrypoint.sh