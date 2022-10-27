FROM debian:bullseye-slim

RUN apt update

RUN apt install wget curl -y

RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup

RUN ls -al

RUN echo "733cf126b03f73050e242102592658913d10829a5bf056ab77e7f864b3f8de1f mariadb_repo_setup" | sha256sum -c -

RUN chmod +x ./mariadb_repo_setup

RUN ./mariadb_repo_setup --mariadb-server-version="mariadb-10.6"

#FROM mariadb:10.6.10

RUN apt update

RUN apt install libjemalloc2 -y
RUN apt install mariadb-server mariadb-backup libmariadb3 mariadb-client mariadb-plugin-columnstore -y

COPY scripts/columnstore-init \
    scripts/columnstore-start \
    scripts/columnstore-stop \
    scripts/columnstore-restart \
    scripts/start-services /usr/bin/

RUN touch /etc/columnstore/cmapi_server.conf

RUN chmod +x /usr/bin/columnstore-init \
    /usr/bin/columnstore-start \
    /usr/bin/columnstore-stop \
    /usr/bin/columnstore-restart \
    /usr/bin/start-services

VOLUME ["/etc/columnstore", "/var/lib/columnstore", "/var/lib/mysql"]

# Copy entrypoint to image
COPY scripts/docker-entrypoint.sh /usr/bin/

# Make entrypoint executable & create legacy symlink
RUN chmod +x /usr/bin/docker-entrypoint.sh && \
    ln -s /usr/bin/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["start-services"]