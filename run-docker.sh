#!/usr/bin/env bash

#master节点
docker rm -f myes-master
docker run -d -it \
    --restart=always \
    -p 10200:10200 \
    -p 10300:10300 \
    -e ES_CLUSTER_NAME="elastic-cluster" \
    -e ES_NODE_MASTER="true" \
    -e ES_NODE_NAME="master" \
    -e ES_NETWORK_PUBLISH_HOST="192.168.44.173" \
    -e ES_DISCOVERY_HOSTS="[\"192.168.44.173\"]" \
    -v /data/es/master:/usr/share/elasticsearch/data \
    --name myes-master \
    myes

#node-1节点
docker rm -f myes-node-1
docker run -d -it \
    --restart=always \
    -p 10200:10200 \
    -p 10300:10300 \
    -e ES_CLUSTER_NAME="elastic-cluster" \
    -e ES_NODE_MASTER="false" \
    -e ES_NODE_NAME="node-1" \
    -e ES_NETWORK_PUBLISH_HOST="192.168.44.174" \
    -e ES_DISCOVERY_HOSTS="[\"192.168.44.173\"]" \
    -v /data/es/node-1:/usr/share/elasticsearch/data \
    --name myes-node-1 \
    myes