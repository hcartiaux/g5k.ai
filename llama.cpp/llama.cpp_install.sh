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

gfxvers=$(rocm-smi --showproductname | awk '/.*GFX Version.*/ {print $5}' | head -n1)

cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=${gfxvers} -DCMAKE_BUILD_TYPE=Release

cmake --build build --config Release -- -j $(nproc)

ln -sf /tmp/ /root/.cache
