#!/bin/bash

ONEAPI_DEVICE_SELECTOR="level_zero:1" ZE_FLAT_DEVICE_HIERARCHY=COMPOSITE ./build-sycl/bin/llama-server   -m /mnt/1TB/AI/chat_models/Qwen3.5-9B-Q5_K_M.gguf   -c $((32768 * 2))  -ngl 99  -n 4096   --host 0.0.0.0   --port 8080   -np 1   -ctk q8_0   -ctv q8_0   -b 4096   -ub 2048  --jinja

