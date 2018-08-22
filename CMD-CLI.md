#OpenShift Origin v3.9 CLI @ mclitao

#基础操作命令
######使用超级管理员登录目标master
```batch
# oc login -u system:admin https://172.16.5.131:8443
```
######查看当前用户登录到那台服务器
```batch
# oc whoami --show-server
https://172.99.0.88:8443
```
######登录用户是谁,以及令牌token
```batch
#  oc login -u developer
# oc whoami 
# oc whoami --show-token
```
######使用管理员登录仓库
```batch
# oc login -u system:admin https://172.16.5.131:8443
# docker login -u admin -p $(oc whoami -t)  docker-registry.default.svc:5000
```
######查看用户|添加用户|删除用户|修改密码|查看admin用户的全部权限明细
```batch
# oc get user
NAME      UID                                    FULL NAME   IDENTITIES
admin     14480df8-8340-11e8-8b37-000c293e7d45               htpasswd_auth:admin
# htpasswd -b /etc/origin/master/htpasswd <dev> <密码>
# tpasswd -D /etc/origin/master/htpasswd <user_name>
# htpasswd -c -b <user_name> <password>
# oc describe clusterrole admin
```
######查看已登录用户身份
```batch
# oc get identity
NAME                  IDP NAME        IDP USER NAME   USER NAME   USER UID
htpasswd_auth:admin   htpasswd_auth   admin           admin       14480df8-8340-11e8-8b37-000c293e7d45
```
######全部集群的角色列表\角色内容|工作组
```batch
#  oc get clusterroles
# oc describe clusterrole cluster-admin
# oc get groups
```
######还原密码  查看一个密码配置文件中的base64加密前的原密码
```batch
# oc get secret --namespace myapp virtuous-echidna-redis -o jsonpath="{.data.redis-password}" | base64 --decode
# oc get secret webconsole-serving-cert --namespace openshift-web-console -o jsonpath="{.data.tls\.key}" | base64
  以输出json
# oc get secret webconsole-serving-cert --namespace openshift-web-console -o json
  以输出yaml
# oc get secret webconsole-serving-cert --namespace openshift-web-console -o yaml 
  base64加密
# echo "要加密的原文" | base64
  base64解密
# echo 5Yqg5a+G5a2X56ym5Y6f5paHCg== | base64 -d
```
######将secrets的配置内容保存成文件
```batch
# oc secrets new <配置名>  datasources.env
```
######给普通用户编译镜像的权利
```batch
# oadm policy add-role-to-user system:registry user
# oadm policy add-role-to-user system:image-builder user
```
######
```batch

```

#项目操作命令
######新建 删除 进入 项目 | 停止项目 | 开启项目 |3种部署代码的方法
```batch
# oc new-project <项目名>
# oc delete project <项目名>
# oc project <项目名>
 --------------将一个应用的实例全部关闭掉------------------- 
# oc scale --replicas=0 dc <dcname>
 --------------将关闭的应用项目打开------------------------- 
# oc scale --replicas=1 dc <dcname>
 -------------镜像 + 代码 部署------------------------------
# oc new-app 厂家/镜像语言平台~https://github.com/openshift/ruby-hello-world.git
--------------镜像Ruby-20-centos7:latest + 目录的源代码-----
# oc new-app openshift/ruby-20-centos7:latest~/home/user/code/my-ruby-app
--------------镜像 + ENV参数--------------------------------
# oc new-app openshift/postgresql-92-centos7 --env-file=postgresql.env
```
######暂停 | 恢复 项目
```batch
# oc rollout pause dc sonar
# oc rollout resume dc sonar
```
######设置项目使用的资源大小
```batch
# oc set resources dc/sonar --limits=memory=2Gi --requests=memory=1Gi
# oc set resources dc/minio --limits=cpu=4,memory=8Gi --requests=cpu=100m,memory=512Mi
```
######使用挂载pvc存储 | 移除pvc存储
```batch
# 建立100G大小的pvc名字为minio-pvc-data 绑定到pod的minio-volume-1下对应是容器里面的/data/目录
# oc volumes dc/minio --add \
    --name 'minio-volume-1' \
    --type 'pvc' \
    --mount-path '/data/' \
    --claim-name 'minio-pvc-data' \
    --claim-size '100G' \
    --overwrite      
# 从写挂载pvc到挂载点minio-volume-1上
# oc volumes  --add dc/minio --name=minio-volume-1 -t pvc --claim-name=minio-pvc-data --overwrite

# 移除minio-volume-1的存储挂载点
# oc set volumes dc/minio --remove --name=minio-volume-1
# 添加现有的pvc到对应的挂载位置    
# oc set volumes dc/minio --add --name=minio-data --mount-path=/data/ --type persistentVolumeClaim --claim-name=minio-pvc-data

```
######容器健康检查 liveness活性探针  readiness状态探针
```batch
    --liveness                     活性探针
    --readiness                    状态探针
     
    --failure-threshold 3          做多失败次数3次
    --initial-delay-seconds 5      容器首次启动时延迟5秒执行
    --timeout-seconds 1            超时设置为2秒
    --period-seconds 20            每个10秒监测一次
    --get-url=http://:9000/minio/health/live  访问http协议 9000端口 地址 minio/health/live
例子：
    # 用来监控容器内服务是否健康
    oc set probe dc/minio \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 5 \
        --timeout-seconds 1 \
        --period-seconds 20 \
        --get-url=http://:9000/minio/health/ready
   # 用来监控容器是否健康
   # oc set probe dc/minio \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 5 \
        --timeout-seconds 1 \
        --period-seconds 20 \
        --get-url=http://:9000/minio/health/live
```
######获取limits | Quotas 等资源情况以及修改调整
```batch
# oc get resourcequota
# oc get limits
# oc describe resourcequota <名>
# oc describe limits <名>
```
######获取具体项目内容配置名字
```batch
 ----------------dc,rs,rs,po,sv,route等名字------------ 
# oc get all -o name
 ----------------只要app名字=demo2的内容--------------- 
oc get all -o name --selector app=demo2
 ----------------查看具体实时日志----------------------
# oc logs build/jee-ex-1   --follow
```
######根据已经部署的实例生成template
```batch
# oc export dc,svc,route --as-template=minio.yaml > minio5.yaml
```
######手动调试启动目标部署这样就可以逐步排查问题了
```batch
# oc debug dc/项目名
```
######查看app的部署进度状况
```batch
# oc rollout status deployment <app> 
```
######删除一个app的全部内容
```batch
# oc delete all --selector app=nettest
  或  
# oc delete all -l app=nettest
```
######分配privileged的gcc特权给目标项目下的服务账号
```batch
# oc adm policy add-scc-to-user privileged system:serviceaccount:sysdig-account:sysdig
```
######调整app内的参数方法|查看参数方法|修改参数方法
```batch
 调整dc/blog的某个参数
# oc set env bc/blog UPGRADE_PIP_TO_LATEST=1
 查看全部env环境信息
# oc set env dc/jenkins  --list     
 使用命令修改dc部署环境中的使用镜像名字
# oc patch dc nginx -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"harbor.apps.example.com/public/nginx:1.14"}]}}}}'
 使用patch修正参数来向oauthclient/openshift-web-console -p参数增加一个数据
# oc patch oauthclient/openshift-web-console -p '{"redirectURIs":["https://localhost:9000"]}'
```
######手动命令暴露Pod一个新的port端口 
```batch
   给目标pods定义一个新的端口5000，并将端口暴露出来作为service，并建立路由
# oc patch dc nexus -p '{"spec":{"template":{"spec":{"containers":[{"name":"nexus","ports":[{"containerPort": 5000,"protocol":"TCP","name":"docker"}]}]}}}}'
# oc expose dc nexus --name=nexus-registry --port=5000
# oc create route edge nexus-registry --service=nexus-registry
```
######查看pods的标签lables内容
```batch
# 查看具体pods上的对应标签内容
#  oc get pods  --show-labels=true |grep jenkins
NAME                        READY     STATUS        RESTARTS   AGE       LABELS
jenkins-2-zkzrj             1/1       Running       0          1h        deployment=jenkins-2,deploymentconfig=jenkins,name=jenkins
```
######强制替换现有的一个模板  replace --force
```batch
# oc replace --force -f https://gitlab.com/oprudkyi/openshift-templates/raw/master/php-fpm/php-fpm.yaml -n openshift
```
######测试一个项目是否可以实际部署成功
```batch
# oc set build-hook bc/blog --pose-commit --script "powershift image verify"
```

#集群操作命令
###### 看节点 输出标签 另一个是输出具体细节
```batch
[root@master-39-1 ~]# oc get node --show-labels=true 
[root@master-39-1 ~]# oc get nodes -o wide
```