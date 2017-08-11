#! /usr/bin/env bash
#
# run.sh
#

name=reverse-proxy

if docker ps -f name=$name | grep $name; then
  echo "$name is running"
  exit 0
fi

docker run -d --name=$name -p "80:80" \
  -v "$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf" \
  -v "$(pwd)/nginx/keepwork.dev.test.template:/etc/nginx/conf.d/keepwork.dev.test.template" \
  -v "$(pwd)/nginx/html:/usr/share/nginx/html" \
  --link keepwork-dev-server \
  --link keepwork-test-server \
  --link keepwork-prod-server \
  -e "DOLLAR=$$" \
  -e "DEV_ADDRESS=dev.keepwork.com" \
  -e "DEV_HOST=keepwork-dev-server" \
  -e "DEV_PORT=8900" \
  -e "TEST_ADDRESS=test.keepwork.com" \
  -e "TEST_HOST=keepwork-test-server" \
  -e "TEST_PORT=8099" \
  nginx \
  /bin/bash -c "envsubst </etc/nginx/conf.d/keepwork.dev.test.template >/etc/nginx/conf.d/keepwork.dev.test.conf && nginx -g 'daemon off;'"
