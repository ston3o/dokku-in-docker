#!/usr/bin/env bash

# Install dokku-api
if [ -f "/root/.firstrun" ]; then
    dokku plugin:install https://github.com/dokku/dokku-postgres.git
    dokku plugin:install https://github.com/dokku/dokku-redis.git
fi

if [ -f "/root/.firstrun" ]; then
    unlink /root/.firstrun
fi
