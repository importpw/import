#!/bin/sh
cd test
exec nginx \
  -p "$PWD/" \
  -c "$PWD/nginx.conf" \
  -g 'daemon off;'
