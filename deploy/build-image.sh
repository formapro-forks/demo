#!/usr/bin/env bash

set -x
set -e

if (( "$#" != 1 ))
then
    echo "Tag has to be provided"
    exit 1
fi

rm -rf /tmp/symfony-demo

cp -r . /tmp/symfony-demo
rm -rf /tmp/symfony-demo/vendor
rm -rf /tmp/symfony-demo/var/cache
rm -rf /tmp/symfony-demo/var/logs
rm -rf /tmp/symfony-demo/.git

mkdir -p /tmp/symfony-demo/var/cache/prod
mkdir -p /tmp/symfony-demo/var/logs
chmod -R a+rwX /tmp/symfony-demo/var

(cd /tmp/symfony-demo; composer install --prefer-dist --no-dev --ignore-platform-reqs --no-scripts --optimize-autoloader --no-interaction)

cp -f deploy/.env /tmp/symfony-demo
sh -ac 'cd /tmp/symfony-demo; source .env; bin/console cache:warmup'

(cd /tmp/symfony-demo; docker build --rm --pull --force-rm --tag "formapro/symfony-demo:$1" -f deploy/Dockerfile .)

docker login --username="$DOCKER_USER" --password="$DOCKER_PASSWORD"
docker push "formapro/symfony-demo:$1"
