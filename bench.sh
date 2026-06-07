#!/bin/bash
MODEL=${1}
BUILD_DIR=build-vulkan
GPU_DEVICES=${GPU_DEVICES:-0,1}

if [[ "$@" == *"SYCL"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    #export GGML_SYCL_VISIBLE_DEVICES=$GPU_DEVICES
    #export ONEAPI_DEVICE_SELECTOR="level_zero:0"
    BUILD_DIR=build-sycl
    echo "SYSMAN ENABLED"
fi

if [[ "$@" == *"OPENVINO"* ]]; then
   source /opt/intel/openvino/setupvars.sh
   BUILD_DIR=build-openvino
   export GGML_OPENVINO_DEVICE=GPU.0
   echo "USING OPENVINO"
fi

/mnt/1TB/AI/llama.cpp/llama.cpp/$BUILD_DIR/bin/llama-bench \
    --model $MODEL \
    -p 8192 \
    -fa on \
    -ngl 99 \
    --mmap \
    -v \
    --progress \
    -ctk q8_0 \
    -ctv q8_0 \
    -b 4096 \
    -ub 4096 \
    -n 256 \
    -r 3
