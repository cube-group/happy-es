FROM bachue/elasticsearch-ik:6.2.4

#集群名称
ENV ES_CLUSTER_NAME "elastic-cluster"
#该集群节点名称
ENV ES_NODE_NAME "master"
#该集群节点是否为master节点
ENV ES_NODE_MASTER "true"
#该集群节点是否可以进行存储
ENV ES_NODE_DATA "true"
#该集群节点向外暴露的服务ip
ENV ES_NETWORK_PUBLISH_HOST "127.0.0.1"
#集群服务发现地址,如:"[\"127.0.0.1\"]"
ENV ES_DISCOVERY_HOSTS ""

#RUN echo "https://mirrors.aliyun.com/alpine/v3.8/main/" > /etc/apk/repositories && \
#    echo "https://mirrors.aliyun.com/alpine/v3.8/community/" >> /etc/apk/repositories && \
#    apk update && apk add curl
COPY plugins/elasticsearch-analysis-ik-6.2.4.zip /elasticsearch-analysis-ik-6.2.4.zip
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY supervisor.conf /supervisor.conf
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord
COPY run.sh /run.sh

RUN unzip -o /elasticsearch-analysis-ik-6.2.4.zip -d plugins && \
    mv plugins/elasticsearch plugins/ik && \
    ls -al plugins/ik/

EXPOSE 10200 10300

ENTRYPOINT ["/bin/sh"]
CMD ["/run.sh"]