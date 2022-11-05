#!/usr/bin/env bash

MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

# @author jinsoo.kim <jjambbongjoa@gmail.com>

echo -e "${MSG_PREFIX}nodejs 패키지 업데이트 및 vuejs 빌드 작업시작...\n"

docker-compose exec nodejs sh -c 'NODE_ENV=development && yarn install && NODE_ENV=production && yarn build'

echo -e "${MSG_PREFIX}nodejs 패키지 업데이트 및 vuejs 빌드 작업완료\n"
echo -e "${MSG_PREFIX}nginx public 파일 대체 및 reload 작업시작...\n"

docker-compose exec nginx sh -c 'rm -rf /var/workspace/dist/public && yes |cp -arpf /var/workspace/nodejs/dist /var/workspace/dist/public'

docker-compose exec nginx sh -c 'service nginx reload'

echo -e "${MSG_PREFIX}nginx public 파일 대체 및 reload 작업완료\n"

