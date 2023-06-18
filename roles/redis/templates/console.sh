#!/bin/bash

sudo docker exec -it redis redis-cli --pass {{ vault_redis_password }} --no-auth-warning
