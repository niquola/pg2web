#!/bin/bash

rm  .build/nginx/conf/nginx.conf
ln -s cfg/nginx.conf .build/nginx/conf/nginx.conf
ls -lah .build/nginx/conf/nginx.conf

nginx -s reload -c cfg/nginx.conf
