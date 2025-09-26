#!/bin/bash
#OAR -l nodes=1,walltime=6:00:0
#OAR -p larochette
#OAR -t deploy

# Configuration
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NODE=$(cat $OAR_NODEFILE | sort -u)
SSH="ssh -o StrictHostKeyChecking=no root@${NODE}"
SCP="scp -o StrictHostKeyChecking=no"

# Model
model_file=unsloth_gpt-oss-120b-GGUF_gpt-oss-120b-F16.gguf
mirror="http://public.luxembourg.grid5000.fr/~hcartiaux/llama.cpp/"
destination=/tmp

# Node environment
kadeploy3 ubuntu2404-rocm

# Download the model
$SSH wget -c "${mirror}/${model_file}" -P "${destination}"

$SCP "${WORKING_DIR}/llama.cpp_install.sh" root@${NODE}:

$SSH bash -x ./llama.cpp_install.sh

# Use local file
$SSH CUDA_VISIBLE_DEVICES=0,1 $destination/llama.cpp/build/bin/llama-server -m "${destination}/${model_file}" --host 0.0.0.0 --port 11434 --ctx-size 131072 --jinja
