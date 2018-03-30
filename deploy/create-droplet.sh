#!/usr/bin/env bash

set -x
set -e

DROPLET_NAME='symfony.demo'
echo "Droplet name: $DROPLET_NAME"

docker-machine create \
    --driver digitalocean \
    --digitalocean-image ubuntu-16-04-x64 \
    --digitalocean-access-token "$DOTOKEN" \
    --digitalocean-region "ams3" \
    --digitalocean-size "1gb" \
    --digitalocean-ssh-key-fingerprint "$SSH_KEY_FINGERPRINT" \
    "$DROPLET_NAME"

DROPLET_IP=`docker-machine ip $DROPLET_NAME`
echo "Droplet IP: $DROPLET_IP"

docker-machine ssh "$DROPLET_NAME" \
    "docker swarm init --advertise-addr $DROPLET_IP";

# run the command if you need an access to private Docker registry.
#docker-machine ssh "$DROPLET_NAME" \
#    "docker login --username="$DOCKER_USER" --password="$DOCKER_PASSWORD";