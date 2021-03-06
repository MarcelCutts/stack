#!/usr/bin/env bash

# run from the root of this repository

nodes=$(docker-machine ip $(docker-machine ls -q))

str=''
for node in $nodes
do
  str="$str  server $node;"
done
echo $str

sed '/upstream web/ a\
'"$str"'\
' < nginx/default.conf > /tmp/default.conf

str=''
for node in $nodes
do
  str="$str  server $node:81;"
done
echo $str

sed '/upstream api/ a\
'"$str"'\
' < /tmp/default.conf > nginx/new.conf

rm /tmp/default.conf

docker run -d -p 80:80 -v $(pwd)/nginx/new.conf:/etc/nginx/conf.d/default.conf --name load-balancer nginx
