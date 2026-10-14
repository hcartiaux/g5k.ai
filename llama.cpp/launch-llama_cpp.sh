#!/bin/bash
#OAR -l nodes=1/gpu=1,walltime=1:00:0

# Configuration
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Model
model_file=unsloth_gpt-oss-120b-GGUF_gpt-oss-120b-F16.gguf
mirror="http://public.luxembourg.grid5000.fr/~hcartiaux/llama.cpp/"
destination=/tmp

# Download the model
wget -c "${mirror}/${model_file}" -P "${destination}"

# Software modules
unset BASH_ENV
module load rocm-toolchain
module load rocm-cmake
module load rocm-hip-runtime
module load rocblas
module load hipblas

# Build llama.cpp locally
bash -x "${WORKING_DIR}/llama.cpp_install.sh"

# Preserve the user's home directory
[ ! -e ~/.cache ] && ln -sf /tmp/ ~/.cache

# Use local file
$destination/llama.cpp/build/bin/llama-server -m "${destination}/${model_file}" --host 0.0.0.0 --port 11434 --ctx-size 131072 --jinja
