#!/bin/bash
SERVICE_NAME=${SERVICE_NAME:-llamacpp}
sudo systemctl restart $SERVICE_NAME && sudo journalctl -u $SERVICE_NAME -f
