#!/bin/bash

# Dependencies
apt install -y cmake libcurl4-openssl-dev hipcc

# Download the model
cd /tmp

# Build llama.cpp
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
export HIPCXX="$(hipconfig -l)/clang"
export HIP_PATH="$(hipconfig -R)"

# For larochette
cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx90a -DCMAKE_BUILD_TYPE=Release
# For vianden
# cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx942 -DCMAKE_BUILD_TYPE=Release

cmake --build build --config Release -- -j $(nproc)

ln -sf /tmp/ /root/.cache
