#!/bin/bash
MODEL_PATH=${MODEL_PATH:-/mnt/1TB/AI/chat_models}
MODEL=${MODEL:-google_gemma-4-26B-A4B-it-Q6_K_L.gguf}
MODEL_ALIAS=${MODEL_ALIAS:-gemma4:26b-a4b}
PORT=${PORT:-8080}
BUILD_DIR=${BUILD_DIR:-build-vulkan}
BATCH_SIZE=${BATCH_SIZE:-8192}
UBATCH_SIZE=${UBATCH_SIZE:-1024}
CONTEXT_SIZE=${CONTEXT_SIZE:-32768}

if [[ "$BUILD_DIR" == *"sycl"* ]]; then
    source /opt/intel/oneapi/setvars.sh
    export ZES_ENABLE_SYSMAN=1
    export GGML_SYCL_VISIBLE_DEVICES=0,1,2
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
    --model "$MODEL_PATH/$MODEL" \
    --jinja \
    --alias $MODEL_ALIAS \
    --port $PORT \
    --host 0.0.0.0 \
    --fit on \
    -ngl 999 \
    -np 1 \
    -fa on \
    -t 4 \
    --mmap \
    -sm tensor \
    --reasoning on \
    -c "$CONTEXT_SIZE" \
    2>&1 | tee /tmp/llama-8080.log
