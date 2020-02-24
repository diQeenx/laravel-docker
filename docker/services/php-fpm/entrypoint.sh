#!/bin/sh

set -ex

if [ ! -f "/usr/bin/composer" ]; then
  docker-php-composer-install.sh;
fi

exec docker-php-entrypoint "$@"