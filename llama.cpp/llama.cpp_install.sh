#!/bin/bash

cd /tmp
[ -d llama.cpp ] || git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
rm -rf build

gfxvers=$(rocminfo | grep -o -m1 -E 'gfx[0-9a-f]+' | head -n1)
echo "GPU target: $gfxvers"

RUNTIME_DIR="$(echo "${CMAKE_PREFIX_PATH}" | tr ':' '\n' \
             | grep 'rocm-hip-runtime' | sort | head -n1)"

cmake -S . -B build                \
    -DGGML_HIP=ON                  \
    -DAMDGPU_TARGETS=${gfxvers}    \
    -DCMAKE_BUILD_TYPE=Release     \
    -DCMAKE_HIP_COMPILER_ROCM_ROOT="$RUNTIME_DIR"

cmake --build build --config Release -- -j $(nproc)
