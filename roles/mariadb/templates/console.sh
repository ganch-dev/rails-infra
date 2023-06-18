#!/bin/bash

docker exec -it mariadb mysql -u root -p{{ vault_mariadb_password }}
