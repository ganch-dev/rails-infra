#!/bin/bash

set -e
docker run -p 127.0.0.1:6379:6379 \
           -d \
           --name redis \
           -v /opt/redis/data:/data \
           -v /opt/redis/config:/usr/local/etc/redis \
           {{ redis_image }} \
           --requirepass {{ vault_redis_password }} \
           --save 60 1 \
           --loglevel warning
