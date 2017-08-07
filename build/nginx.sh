#!/usr/bin/env bash

if [[ $(service nginx status > /dev/null 2>&1) ]]; then
    nginx
fi

sleep 360
