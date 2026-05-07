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
   export GGML_OPENVINO_DEVICE=GPU.0
   echo "USING OPENVINO"
fi

/mnt/1TB/AI/llama.cpp/$BUILD_DIR/bin/llama-server \
    --model $MODEL \
    --jinja \
    --alias $MODEL_ALIAS \
    --port $PORT \
    --host 0.0.0.0 \
    --temp 0.7 \
    --min-p 0.0 \
    --top-p 0.80 \
    --top-k 20 \
    --repeat-penalty 1.05
