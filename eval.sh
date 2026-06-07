#!/bin/bash

SERVER=$1
MODEL=$2
DATASET=${3:-aime2026}
CASES=${4:-240}

python3 ./llama.cpp/examples/llama-eval/llama-eval.py --resume --server $SERVER --dataset $DATASET --n_cases $CASES --model $MODEL --verbose --grader-type regex --output ${MODEL//:/-}-$DATASET.json
