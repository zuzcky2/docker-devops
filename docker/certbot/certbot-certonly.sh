#!/usr/bin/env bash

certbot certonly --dns-route53 -d ${SERVER_NAME} -d *.${SERVER_NAME} --email ${MAINTAINER}
