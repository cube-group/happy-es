#!/bin/bash

esConfig=/usr/share/elasticsearch/config/elasticsearch.yml

# Increase ES_CLUSTER_NAME
if [ ! -z "$ES_CLUSTER_NAME" ]; then
 sed -i "s#cluster.name: elasticsearch#cluster.name: ${ES_CLUSTER_NAME}#g" ${esConfig}
fi

# Increase ES_NODE_NAME
if [ ! -z "$ES_NODE_NAME" ]; then
 sed -i "s#node.name: node-name#node.name: ${ES_NODE_NAME}#g" ${esConfig}
fi

# Increase ES_NODE_MASTER
if [ ! -z "$ES_NODE_MASTER" ]; then
 sed -i "s#node.master: true#node.master: ${ES_NODE_MASTER}#g" ${esConfig}
fi

# Increase ES_NODE_DATA
if [ ! -z "$ES_NODE_DATA" ]; then
 sed -i "s#node.data: true#node.data: ${ES_NODE_DATA}#g" ${esConfig}
fi

#if [ ! -z "$ES_TCP_PORT" ]; then
# sed -i "s#transport.tcp.port: 9300#transport.tcp.port: ${ES_TCP_PORT}#g" ${esConfig}
#fi
#
# Increase ES_HTTP_PORT
#if [ ! -z "$ES_HTTP_PORT" ]; then
# sed -i "s#http.port: 9200#http.port: ${ES_HTTP_PORT}#g" ${esConfig}
#fi

# Increase ES_NETWORK_PUBLISH_HOST
#if [ ! -z "$ES_NETWORK_PUBLISH_HOST" ]; then
# sed -i "s#network.host: 0.0.0.0#network.host: ${ES_NETWORK_PUBLISH_HOST}#g" ${esConfig}
#fi

# Increase ES_NETWORK_PUBLISH_HOST
#if [ ! -z "$ES_NETWORK_PUBLISH_HOST" ]; then
# sed -i "s#network.bind_host: 0.0.0.0#network.bind_host: ${ES_NETWORK_PUBLISH_HOST}#g" ${esConfig}
#fi

# Increase ES_NETWORK_PUBLISH_HOST
if [ ! -z "$ES_NETWORK_PUBLISH_HOST" ]; then
 sed -i "s#network.publish_host: 0.0.0.0#network.publish_host: ${ES_NETWORK_PUBLISH_HOST}#g" ${esConfig}
fi

# Increase ES_DISCOVERY_HOSTS
if [ ! -z "$ES_DISCOVERY_HOSTS" ]; then
    sed -i "s;#discovery.zen.ping.unicast.hosts: \[\"127.0.0.1\"\];discovery.zen.ping.unicast.hosts: ${ES_DISCOVERY_HOSTS};g" ${esConfig}
fi

chown -R elasticsearch:root /usr/share/elasticsearch/data

supervisord -c /supervisor.conf