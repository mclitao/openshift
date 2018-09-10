<img src="https://github.com/mclitao/openshift/blob/master/BIGDATA/zookeeper.jpg?raw=true" alt="" width="300"/>


[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/containers/skopeo.svg?branch=master)](https://travis-ci.org/containers/skopeo)


## Zookeeper学习笔记
> 来自[mclitao](https://www.xxx.cn/)[学习笔记](http://xxxxx.cn/)的内容

<h5>ZooKeeper 是一个开源的分布式协调服务，由雅虎创建，是 Google Chubby 的开源实现。
    分布式应用程序可以基于 ZooKeeper 实现：
            数据发布/订阅、负载均衡、命名服务、分布式协调/通知、集群管理、Master 选举、分布式锁和分布式队列等功能。
            典型场景：基于ZAB算法实现决绝分布式环境中数据一致性。
</h5>

### 笔记目录

- **Zookeeper资料**
   - 
    |ID | Name |   Description     |
    |:--|:-----|:----------------- |
    |0|官网地址|https://zookeeper.apache.org/|
    |1|下载地址|http://mirror.bit.edu.cn/apache/zookeeper/|

- **Zookeeper的三种角色**
   -
   ><h6>Leader</h6>
    ```
    领导的意思，负责指挥，不敢具体工作，在同一时间内只能存在一个Leader。只有一个Nimbus。
    ```
   ><h6>Observer </h6>
    ```
    监工，中层领导。
    ```
   ><h6>Follower </h6>
    ```
    随从，负责具体执行的。
    ```

- **Zookeeper配置文件**
  - 
    |ID | 文件列表                              |     描述内容      |
    |:--|:--------------------------------------|:----------------- |
    | 0 |/opt/module/jdk1.8 | java环境版本1.8|
    | 1 |zoo.cfg|集群配置文件|

- **Zookeeper搭建方法**
   -
    ```commandline
    参考为知笔记
    ```
- **基础服务命令**
  - 
    ```
      连接一下集群端口
    # echo stat | nc 127.0.0.1 2183
      状态
    # zookeeper-server status
    ```