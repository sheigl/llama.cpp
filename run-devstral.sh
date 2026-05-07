#!/bin/bash
MODEL=${1}
MODEL_ALIAS=${2}
PORT=${3}
BUILD_DIR=build-vulkan

if [[ "$@" == *"SYCL"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    export GGML_SYCL_VISIBLE_DEVICES=0,1,2
    BUILD_DIR=build-sycl
    echo "SYSMAN ENABLED"
fi

if [[ "$@" == *"OPENVINO"* ]]; then
   source /opt/intel/openvino/setupvars.sh
   BUILD_DIR=build-openvino
   export GGML_OPENVINO_DEVICE=0,1,2
   echo "USING OPENVINO"
fi

/mnt/1TB/AI/llama.cpp/$BUILD_DIR/bin/llama-server \
    --model $MODEL \
    --chat-template-file devstral-fix.jinja \
    --alias $MODEL_ALIAS \
    --port $PORT \
    --host 0.0.0.0 \
    --fit on \
    -ngl 999 \
    -fa on \
    -t 8 \
    -mg 0 \
    -np 1 \
    --mmap \
    -ctk q8_0 \
    -ctv q8_0 \
    -sm layer \
    --batch-size 4096 \
    --ubatch-size 512 \
    --reasoning on \
    -c 100000


