#!/bin/bash

source /opt/intel/oneapi/setvars.sh

# Defaults
C=81920
N_GPU_LAYERS=99
JINJA=true
FA=true
CTV=q8_0
CTK=q8_0
BATCH_SIZE=4096
UBATCH_SIZE=4096
REASONING=on
MMAP=true
METRICS=true
SWA_FULL=true
SLEEP_IDLE=300
NP=1
MG=0
TENSOR_SPLIT="0"
CTX_CHECKPOINTS=128
CHECKPOINT_EVERY=4096

MODEL=""
CHAT_TEMPLATE_KWARGS=""

# Parse model argument
PROFILE="${1:-}"

case "$PROFILE" in
  "qwen3.6:35b-a3b"|"35b")
    MODEL="/mnt/1TB/AI/chat_models/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf"
    CHAT_TEMPLATE_KWARGS='{"preserve_thinking": true}'
    C=262144
    NP=1
    UBATCH_SIZE=2048
    TENSOR_SPLIT="30,15"
    ;;
  *)
    echo "Usage: $0 <profile>"
    echo "Profiles: qwen3.6:35b-a3b, 35b"
    exit 1
    ;;
esac

# Build command
CMD=(
  ./llama.cpp/build-sycl/bin/llama-server
  --model "$MODEL"
  --alias "$PROFILE"
  --host 0.0.0.0
  --port 8080
  -c "$C"
  -ngl "$N_GPU_LAYERS"
  --jinja
  --flash-attn on
  --cache-type-v "$CTV"
  --cache-type-k "$CTK"
  -b "$BATCH_SIZE"
  -ub "$UBATCH_SIZE"
  --reasoning "$REASONING"
  --mmap
  --device SYCL0
  --metrics
  --swa-full
  --sleep-idle-seconds "$SLEEP_IDLE"
  -np "$NP"
  -mg "$MG"
  --tensor-split "$TENSOR_SPLIT"
  --ctx-checkpoints "$CTX_CHECKPOINTS"
  --checkpoint-every-n-tokens "$CHECKPOINT_EVERY"
  -sm layer
  -lv 4
)

[[ -n "$CHAT_TEMPLATE_KWARGS" ]] && CMD+=(--chat-template-kwargs "$CHAT_TEMPLATE_KWARGS")

echo "${CMD[@]}"

GGML_SYCL_DISABLE_OPT=1 "${CMD[@]}"
