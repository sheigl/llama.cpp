#!/bin/bash

# Unload all loaded models by default, or unload a specific model by name

API_URL=${API_URL:-"http://localhost:8080"}

if [ -z "$1" ]; then
  # No argument: unload ALL loaded models
  echo "Fetching loaded models from $API_URL..."
  MODELS=$(curl -s -X GET "$API_URL/models" | jq -r '.data[] | select(.status.value == "loaded") | .id')
  
  if [ -z "$MODELS" ]; then
    echo "No models currently loaded."
    exit 0
  fi
  
  echo "Unloading loaded models:"
  for MODEL in $MODELS; do
    echo "  Unloading: $MODEL"
    curl -s -X POST "$API_URL/models/unload" \
      -H "Content-Type: application/json" \
      -d "{\"model\": \"$MODEL\"}" | jq .
  done
  echo "All loaded models unloaded."
else
  # Argument provided: unload specific model
  MODEL="$1"
  echo "Unloading model: $MODEL"
  curl -s -X POST "$API_URL/models/unload" \
    -H "Content-Type: application/json" \
    -d "{\"model\": \"$MODEL\"}" | jq .
fi