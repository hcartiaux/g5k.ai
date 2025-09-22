#!/bin/bash
#OAR -l nodes=1,walltime=0:30:0
#OAR -q default
#OAR -t exotic
#OAR -t deploy
#OAR -p vianden

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
UNAME_S=Linux
UNAME_M=x86_64

SSH="ssh -o StrictHostKeyChecking=no root@vianden-1"

kadeploy3 -m vianden-1 ubuntu2404-rocm

# Install Docker manually (replicate `g5k-setup-docker -t`)
$SSH mkdir -p /tmp/docker
$SSH mkdir -p /var/lib/docker
$SSH mount --bind /tmp/docker /var/lib/docker
curl -sSL https://get.docker.com/ | $SSH sh
$SSH curl -sSL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-${UNAME_S}-${UNAME_M}" -o /usr/local/bin/docker-compose
$SSH chmod +x /usr/local/bin/docker-compose
$SSH mkdir -p /etc/docker
echo "{ \"registry-mirrors\": [\"http://docker-cache.grid5000.fr\"] }" | $SSH tee /etc/docker/daemon.json
$SSH systemctl restart docker
$SSH chmod o+rw /var/run/docker.sock

# Create the Ollama and OpenWebUI directories
$SSH mkdir -p /tmp/ollama /tmp/open-webui
$SSH chown -R 1000:1000 /tmp/ollama /tmp/open-webui

# Start the docker containers
$SSH sudo -u $USER -i "bash -c 'cd $WORKING_DIR && docker compose up -d'"
$SSH sudo -u $USER -i "bash -c 'cd $WORKING_DIR && docker compose logs -f'"
