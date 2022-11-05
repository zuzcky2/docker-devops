#!/usr/bin/env bash

/opt/conda/bin/jupyter notebook > /var/workspace/log/jupyter.log 2>&1 & \
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --proxy-headers --root-path / --forwarded-allow-ips="*" --reload > /var/workspace/log/Router.log 2>&1