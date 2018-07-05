


#### nexus2 私有仓库部署
```batch
# install nexus2
 oc new-app sonatype/nexus

# install nexus3
 oc new-app sonatype/nexus3
 oc expose svc/nexus
# ==============add volume of nexus============= #
 oc volume dc/nexus --add --name=nexus-storage -t pvc \
     --claim-name=nexus-claim --overwrite

```



###kong-template.yaml
kong

###pipeline.yaml
pipeline for kalix project

## add volume to jenkins-maven-slave

> ref to https://blog.openshift.com/decrease-maven-build-times-openshift-pipelines-using-persistent-volume-claim/

## kalix-release
   oc new-app --strategy=source openshift/kalix-s2i~https://github.com/chenyanxu/tools-parent.git --context-dir=tools-karaf-assembly -e 'MAVEN_ARGS=mvn clean install karaf:assembly karaf:archive' --name=karaf-release
## postgresql
   oc new-app sameersbn/postgresql -e 'PG_PASSWORD=1234' -e 'DB_NAME=kalix'






