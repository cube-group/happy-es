## es集群
### 宿主机设置
```
sysctl -w vm.max_map_count=655360
```
### 启动容器
* 启动master
```
docker run -d -it \
    --restart=always \
    -p 10200:10200 \
    -p 10300:10300 \
    -e ES_CLUSTER_NAME="elastic-cluster" \
    -e ES_NODE_MASTER="true" \
    -e ES_NODE_NAME="master" \
    -e ES_NETWORK_PUBLISH_HOST="192.168.44.173" \
    -e ES_DISCOVERY_HOSTS="[\"192.168.44.173\",\"192.168.44.174\"]" \
    -v /data/es/master:/usr/share/elasticsearch/data \
    your-build-es-image
```
* 启动node
```
docker run -d -it \
    --restart=always \
    -p 10200:10200 \
    -p 10300:10300 \
    -e ES_CLUSTER_NAME="elastic-cluster" \
    -e ES_NODE_MASTER="false" \
    -e ES_NODE_NAME="node-1" \
    -e ES_NETWORK_PUBLISH_HOST="192.168.44.174" \
    -e ES_DISCOVERY_HOSTS="[\"192.168.44.173\",\"192.168.44.174\"]" \
    -v /data/es/node-1:/usr/share/elasticsearch/data \
    your-build-es-image
```
### 修改初始超管账号elastic密码
进入容器相应目录执行如下命令,然后输入多次密码即可
```
bin/x-pack/setup-passwords interactive
```
### es常用http api
* 查询所有用户
```
curl --request GET \
  --url http://172.0.0.1:10200/_xpack/security/user \
  --header 'authorization: Basic xxxxxxxxx'
```
* 查询某个用户
```
curl --request GET \
  --url http://172.0.0.1:10200/_xpack/security/user/elastic \
  --header 'authorization: Basic xxxxxxxxx'
```
* 添加用户
```
curl --request POST \
  --url http://172.0.0.1:10200/_xpack/security/user/yourname \
  --header 'authorization: Basic xxxxxxxxx' \
  --header 'content-type: application/json' \
  --data '{\n"password":"xxxxx",\n"roles":["watcher_user"]\n}'
```
* 重置用户密码
```
curl --request PUT \
  --url http://172.0.0.1:10200/_xpack/security/user/test \
  --header 'authorization: Basic xxxxxxxxx=' \
  --header 'content-type: application/json' \
  --data '{"password":"test123456","roles":["other1"]}'
```
* 重置用户密码
```
curl --request PUT \
  --url http://172.0.0.1:10200/_xpack/security/user/test \
  --header 'authorization: Basic xxxxxxxxx=' \
  --header 'content-type: application/json' \
  --data '{"password":"test123456","roles":["other1"]}'
```
* 禁用用户
```
curl --request PUT \
  --url http://172.0.0.1:10200/_xpack/security/user/test/_disable \
  --header 'authorization: Basic xxxxxxxxx'
```
* 恢复用户
```
curl --request PUT \
  --url http://172.0.0.1:10200/_xpack/security/user/test/_enable \
  --header 'authorization: Basic xxxxxxxxx='
```
* 删除用户
```
curl --request DELETE \
  --url http://172.0.0.1:10200/_xpack/security/user/test \
  --header 'authorization: Basic xxxxxxxxx='
```
* 查询用户权限
```
curl --request GET \
  --url http://172.0.0.1:10200/_xpack/security/user/_has_privileges \
  --header 'authorization: Basic xxxx='
```
* 所有权限查询
```
curl --request GET \
  --url http://127.0.0.1:10200/_xpack/security/role \
  --header 'authorization: Basic xxx='
```
* 添加索引
```
curl --request PUT \
  --url http://127.0.0.1:10200/index-name \
  --header 'authorization: Basic xxxxx=' \
  --header 'content-type: application/json' \
  --data ' \
{ \
    "settings":{
        "number_of_shards": "6",
        "number_of_replicas": "1",
         //指定分词器
        "analysis":{
          "analyzer":{
            "ik":{
              "tokenizer":"ik_max_word"
            }
          }
        }
      },
    "mappings":{
	   "index_type":{
		  "properties":{
			 "ID":{
				"type":"string",
				"index":"not_analyzed"
			 },
			 "NAME":{
				"type":"string",
				"fields":{
					"NAME":{
						"type":"string"
					},
					"raw":{
						"type":"string",
						"index":"not_analyzed"
					}
				}
			 }
		  }
	   }
	}
}\

```
* 查询
```
curl --request GET \
  --url http://127.0.0.1:10200/index-name/type-name/xxx \
  --header 'authorization: Basic xxxxx=' \
  --header 'content-type: application/json' \
  --data '{"content":"xxx"}'
```
* 模糊查询
```
curl --request GET \
  --url 'http://127.0.0.1:10200/index-name/type-name/_search?q=content:aaa&size=2&sort=_score:asc' \
  --header 'authorization: Basic xxxx='
```
* 更新内容
```
curl --request POST \
  --url http://127.0.0.1:10200/index-name/type-name/xxx/_update \
  --header 'authorization: Basic xxxxx=' \
  --header 'content-type: application/json' \
  --data '{"doc":{"content":"xxx"}}'
```
* 删除索引
```
curl --request DELETE \
  --url 'http://127.0.0.1:10200/index-name/type-name/1' \
  --header 'authorization: Basic xxx='
```