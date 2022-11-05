#!/usr/bin/env bash

MSG_COLOR="\033[1;32m"
MSG_RESET="\033[0m"
MSG_PREFIX="${MSG_COLOR}[Jinsoo.Kim@IAPI-WORK-STATUS]$ ${MSG_RESET}"

# @author jinsoo.kim <jjambbongjoa@gmail.com>

echo -e "${MSG_PREFIX}php composer 패키지 업데이트 및 opcache 리셋 작업시작...\n"

docker-compose exec php-fpm sh -c 'composer update && composer dump-autoload && composer install --optimize-autoloader --no-dev '
docker-compose exec php-fpm sh -c 'php -r "opcache_reset();" && php artisan cache:clear'

echo -e "${MSG_PREFIX}php composer 패키지 업데이트 및 opcache 리셋 작업완료\n"