#!/bin/bash

sudo systemctl restart llamacpp && sudo journalctl -u llamacpp -f
