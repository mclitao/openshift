
### run example nodejs10 (源码编译部署方式)
```commandline
 oc new-app openshift/nodejs-010-centos7~https://github.com/openshift/nodejs-ex.git
```



### install Postgresql
```commandline
  $ docker pull sameersbn/postgresql
  $ docker tag sameersbn/postgresql 172.30.14.164:5000/openshift/postgresql
  并提交到仓库然后在开始拉起
  $ oc new-app openshift/postgresql -e 'PG_PASSWORD=1234' -e 'DB_NAME=kalix' -e 'REPLICATION_USER=repluser' -e 
  'REPLICATION_PASS=repluserpass'
  $ oc create -f https://github.com/chenyanxu/karaf-s2i/blob/master/postgresql/postgresql-pvc.yaml
  $ oc volumes dc/postgresql --add --claim-name=postgresql --mount-path=/var/lib/postgresql \ -t persistentVolumeClaim
   --overwrite
```



### backup and restore of postgresql
```batch
# Backup your databases
 docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
# Restore your databases
 cat your_dump.sql | docker exec -i your-db-container psql -U postgres
 ```