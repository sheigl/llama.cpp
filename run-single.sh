#!/bin/bash

source /opt/intel/oneapi/setvars.sh
export ZES_ENABLE_SYSMAN=1
export GGML_SYCL_DISABLE_OPT=0
export GGML_SYCL_VISIBLE_DEVICES=1
export UR_L0_ENABLE_RELAXED_ALLOCATION_LIMITS=1

CMD=(
	/mnt/1TB/AI/llama.cpp/llama.cpp/build-sycl/bin/llama-server 
    --port 8081 
    --host 0.0.0.0 
    --model /mnt/1TB/AI/chat_models/mtp/Qwen3.6-27B-UD-Q4_K_XL.gguf 
    --mmproj /mnt/1TB/AI/chat_models/mtp/mmproj-BF16-Qwen3.6-27B.gguf
    --chat-template-file /mnt/1TB/AI/llama.cpp/qwen3.6_chat_template.jinja
    --slot-save-path /mnt/1TB/AI/llama.cpp/save-slots
    --alias qwen3.6-27b-coder 
    --ctx-size 65536 
    --batch-size 4096
    --ubatch-size 4096 
    --device SYCL1
    --tensor-split 0 
    --temp 0.3
    --top-p 0.9
    --top-k 40
    --min-p 0.05
    --presence-penalty 0.0
    --repeat-penalty 1.1
    --spec-draft-device SYCL1
    --spec-type draft-mtp 
    --spec-draft-n-max 2 
    --n-gpu-layers 99 
    --mmap 
    --metrics 
    --jinja 
    --fit on 
    -fa on 
    -ctv q8_0 
    -ctk q8_0 
    --reasoning on 
    -np 1
)


echo ${CMD[@]}
${CMD[@]} --chat-template-kwargs '{"preserve_thinking": true}' 2>&1 | tee /tmp/llama-single.log
