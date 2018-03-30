#!/usr/bin/env bash

set -x
set -e

DROPLET_NAME='symfony.demo'

docker-machine scp deploy/docker-compose.yml symfony.demo:/docker-compose.yml
docker-machine scp deploy/.env $DROPLET_NAME:/.env
docker-machine ssh $DROPLET_NAME "docker stack deploy --prune --with-registry-auth --compose-file /docker-compose.yml symfony_demo"

DEMO_CONTAINER=`docker-machine ssh symfony.demo "docker ps --filter \"name=symfony_demo_symfony_demo\"  --format '{{.ID}}'"`;
echo "Demo container: $DEMO_CONTAINER";
docker-machine ssh $DROPLET_NAME "docker stack deploy --prune --with-registry-auth --compose-file /docker-compose.yml symfony_demo"

docker exec -i "$DEMO_CONTAINER" php load_demo_fixtures.php --drop --trigger=cron