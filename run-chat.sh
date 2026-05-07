#!/bin/bash
MODEL=${1:-/mnt/1TB/AI/chat_models/Qwen3.5-9B-UD-Q4_K_XL.gguf}
MODEL_ALIAS=${2:-qwen3.5:9b}
PORT=${3:-5001}
BUILD_DIR=build-vulkan

if [[ "$@" == *"SYCL"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    BUILD_DIR=build-sycl
    echo "SYSMAN ENABLED"
fi

/mnt/1TB/AI/llama.cpp/$BUILD_DIR/bin/llama-server \
    --model $MODEL \
    --alias $MODEL_ALIAS \
    --port $PORT \
    --host 0.0.0.0 \
    --fit on \
    -ngl 999 \
    -fa on \
    -t 2 \
    -mg 0 \
    --mmap \
    -ctk q8_0 \
    -ctv q8_0 \
    -sm layer \
    --batch-size 4096 \
    --ubatch-size 512 \
    --reasoning on \
    --tensor-split 2,3,3 \
    -c 65536
    #-c 131076  # enable if doing long file/context work
