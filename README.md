# Container postgresql

This project was generated with [Ubuntu:16.04](https://github.com/tianon/docker-brew-ubuntu-core/blob/15a1e4b83d943559f3809ae714aa7045fe5b14a1/xenial/Dockerfile)

## Start a postgres instance  🚀

```bash
docker build -t my_postgresql .
```

## Run the PostgreSQl server container

```bash
docker run --rm -P --name my_pg my_postgresql
```

```bash
Note: The --rm removes the container and its image when the container exits successfully.
```
## Use container linking

```bash
docker run --rm -t -i --link my_pg:pg my_postgresql bash
```
## Connect from your host system

```bash
$ docker ps

CONTAINER ID        IMAGE                  COMMAND                CREATED             STATUS              PORTS                                      NAMES
5e24362f27f6        my_postgresql:latest   /usr/lib/postgresql/   About an hour ago   Up About an hour    0.0.0.0:49153->5432/tcp                    my_pg

$ psql -h localhost -p 49153 -d docker -U docker --password
```
## Test the database 🔩

```bash
psql (9.3.1)
Type "help" for help.

$ docker=# CREATE TABLE cities (
docker(#     name            varchar(80),
docker(#     location        point
docker(# );
CREATE TABLE
$ docker=# INSERT INTO cities VALUES ('San Francisco', '(-194.0, 53.0)');
INSERT 0 1
$ docker=# select * from cities;
     name      | location
---------------+-----------
 San Francisco | (-194,53)
(1 row)
```

## Wiki 📖

[Wiki](https://docs.docker.com/engine/examples/postgresql_service/#use-container-linking)

## Contributing
[Dockerhub](https://hub.docker.com/_/postgres)
