#!/usr/bin/env bash

# Docker 개발환경 Network 초기화
#
# @author jinsoo.kim <jjambbongjoa@gmail.com>
# @since 2021/08/23

cnt=$(docker network list | grep infra | wc -l)
if [[ $cnt -eq 0 ]]; then
    docker network create \
      --driver=bridge \
      --subnet=172.211.0.0/16 \
      --ip-range=172.211.100.0/24 \
      --gateway=172.211.100.254 \
      infra
fi
