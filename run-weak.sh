#!/bin/bash
MODEL=${1:-/mnt/1TB/AI/chat_models/gemma-4-E4B-it-Q4_K_M.gguf}
MODEL_ALIAS=${2:-gemma-4:e4b}
PORT=${3:-8081}
BUILD=${BUILD:-sycl}
BUILD_DIR=build-$BUILD

if [[ "$BUILD" == *"sycl"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    export GGML_SYCL_VISIBLE_DEVICES=0,1,2
    BUILD_DIR=build-sycl
    echo "SYSMAN ENABLED"
fi

if [[ "$@" == *"OPENVINO"* ]]; then
   source /opt/intel/openvino/setupvars.sh
   BUILD_DIR=build-openvino
   export GGML_OPENVINO_DEVICE=GPU.0
   echo "USING OPENVINO"
fi

/mnt/1TB/AI/llama.cpp/$BUILD_DIR/bin/llama-server \
    --model $MODEL \
    --jinja \
    --alias $MODEL_ALIAS \
    --port $PORT \
    --host 0.0.0.0 \
    --fit on \
    -ngl 999 \
    -np 1 \
    -fa on \
    -t 4 \
    -sm layer \
    --reasoning on \
    2>&1 | tee /tmp/llama-8081.log
