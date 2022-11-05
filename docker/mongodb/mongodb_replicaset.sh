#!/usr/bin/env bash

set -e

mongosh -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase "admin" /var/workspace/docker/replicaset.js

