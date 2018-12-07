#!/usr/bin/env bash

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

# Change storage folder's ownership since php-fpm's default user is www-data
chown -R www-data:www-data /app/storage

# Start php-fpm
php-fpm

exec "$@"
