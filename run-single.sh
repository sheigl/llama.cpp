#!/bin/bash

source /opt/intel/oneapi/setvars.sh
export ZES_ENABLE_SYSMAN=1
export GGML_SYCL_DISABLE_OPT=0
export GGML_SYCL_VISIBLE_DEVICES=0
export UR_L0_ENABLE_RELAXED_ALLOCATION_LIMITS=1

/mnt/1TB/AI/llama.cpp/llama.cpp/build-sycl/bin/llama-server \
    --port 8081 \
    --host 0.0.0.0 \
    --model /mnt/1TB/AI/chat_models/mtp/Qwen3.6-27B-UD-Q4_K_XL.gguf \
    --mmproj /mnt/1TB/AI/chat_models/mtp/mmproj-BF16-Qwen3.6-27B.gguf \
    --alias qwen3.6-27b-coder \
    --ctx-size 65538 \
    --batch-size 4096 \
    --ubatch-size 4096 \
    --device SYCL0 \
    --tensor-split 0 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.0 \
    --presence-penalty 0.0 \
    --repeat-penalty 1.0 \
    --spec-type draft-mtp \
    --spec-draft-n-max 2 \
    --chat-template-file /mnt/1TB/AI/llama.cpp/qwen3.6_chat_template.jinja \
    --chat-template-kwargs '{"preserve_thinking": true}' \
    --n-gpu-layers 99 \
    --mmap \
    --metrics \
    --jinja \
    --fit on \
    -fa on \
    -ctv q8_0 \
    -ctk q8_0 \
    --reasoning on \
    -np 2 2>&1 | tee /tmp/llama-single.log
