#!/usr/bin/env bash

if [ -f "/root/.firstrun" ]; then
    dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
fi

if [ -f "/root/.firstrun" ]; then
    unlink /root/.firstrun
fi

sleep 360
