#!/bin/bash
PORT=${PORT:-8080}
BUILD_DIR=${BUILD_DIR:-build-sycl}

if [[ "$BUILD_DIR" == *"sycl"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    #export GGML_SYCL_DISABLE_OPT=1
    export GGML_SYCL_VISIBLE_DEVICES=0,1
    echo "SYSMAN ENABLED"
fi

if [[ "$BUILD_DIR" == *"openvino"* ]]; then
   source /opt/intel/openvino/setupvars.sh
   export GGML_OPENVINO_DEVICE=GPU.0
   echo "USING OPENVINO"
fi

if [[ "$BUILD_DIR" == *"vulkan"* ]]; then
   echo "USING VULKAN"
fi

/mnt/1TB/AI/llama.cpp/$BUILD_DIR/bin/llama-server \
    --models-preset /mnt/1TB/AI/llama.cpp/models.ini \
    --port $PORT \
    --host 0.0.0.0 \
    -t 8 \
    -sm layer 
    2>&1 | tee /tmp/llama-8080.log
