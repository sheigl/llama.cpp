#!/bin/bash

source /opt/intel/oneapi/setvars.sh

/mnt/1TB/AI/llama.cpp/build/bin/llama-server \
    --model $1 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.00 \
    --host 0.0.0.0 \
    --port $2 \
    --kv-unified \
    --cache-type-k bf16 --cache-type-v bf16 \
    --flash-attn on \
    --batch-size 4096 --ubatch-size 1024 \
    --ctx-size 32768 #change as required
