#!/bin/bash

set -e
docker run -p 127.0.0.1:3306:3306 \
           -e MARIADB_ROOT_PASSWORD={{ vault_mariadb_password }} \
           -d \
           --name mariadb \
           -v /opt/mariadb/data:/var/lib/mysql \
           {{ mariadb_image }} --innodb-buffer-pool-size=1G
