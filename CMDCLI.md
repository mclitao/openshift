#集群操作命令
######看节点 输出标签 另一个是输出具体细节
```batch
[root@master-39-1 ~]# oc get node --show-labels=true 
[root@master-39-1 ~]# oc get nodes -o wide
```
######给node节点 打标签label
```batch
  给全部节点打上logging-infra-fluentd标签
# oc label nodes --all logging-infra-fluentd=true
  给一个节点打上logging-infra-fluentd标签
# oc label nodes node1.example.com logging-infra-fluentd=true
  给一个节点打上infra标签
# oc label node node1.example.com infra=yes
  给节点打上compute标签
# oc label node <节点名> node-role.kubernetes.io/compute=true
```
######查看每个节点分配的docker子网信息
```batch
# oc get hostsubnets
  查看消息事件
# oc get event   
```

