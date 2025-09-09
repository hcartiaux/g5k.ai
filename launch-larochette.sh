#!/bin/bash
#OAR -l nodes=1,walltime=1:0:0
#OAR -p larochette

g5k-setup-docker -t

sudo mkdir -p /tmp/ollama /tmp/open-webui
sudo chown -R 1000:1000 /tmp/ollama /tmp/open-webui

docker compose up -d

docker compose logs -f
