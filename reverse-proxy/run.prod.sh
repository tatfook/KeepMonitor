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
  -v "$(pwd)/nginx/keepwork.prod.template:/etc/nginx/conf.d/keepwork.prod.template" \
  -v "$(pwd)/nginx/html:/usr/share/nginx/html" \
  --link keepwork-prod-server \
  -e "DOLLAR=\$" \
  -e "PROD_ADDRESS=keepwork.com" \
  -e "PROD_HOST=keepwork-prod-server" \
  -e "PROD_PORT=8088" \
  nginx \
  /bin/bash -c "envsubst </etc/nginx/conf.d/keepwork.prod.template >/etc/nginx/conf.d/keepwork.prod.conf && nginx -g 'daemon off;'"
