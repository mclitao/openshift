
#### 一千零一种产品编译发布手法
>http://github.com/lbroudoux/openshift-tasks

#### 建立一个docker仓库实例
> oc adm registry

#### nexus2 私有仓库部署
```batch
  install nexus2
# oc new-app sonatype/nexus

  install nexus3
# oc new-app sonatype/nexus3
# oc expose svc/nexus
 ==============add volume of nexus============= 
# oc volume dc/nexus --add --name=nexus-storage -t pvc \
     --claim-name=nexus-claim --overwrite
```

###kong-template.yaml
>kong

###pipeline.yaml
>pipeline for kalix project

#### add volume to jenkins-maven-slave
> ref to https://blog.openshift.com/decrease-maven-build-times-openshift-pipelines-using-persistent-volume-claim/

##### kalix-release
>   oc new-app --strategy=source openshift/kalix-s2i~https://github.com/chenyanxu/tools-parent.git 
--context-dir=tools-karaf-assembly -e 'MAVEN_ARGS=mvn clean install karaf:assembly karaf:archive' --name=karaf-release
##### postgresql
>   oc new-app sameersbn/postgresql -e 'PG_PASSWORD=1234' -e 'DB_NAME=kalix'


### jboos EAP产品Stream
> oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/ose-v1.4.12/eap/eap70-image-stream.json -n openshift



