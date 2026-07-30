#!/bin/bash

source ./common.sh
app_name=catalogue 

check_root 
app_setup 
nodejs_setup
systemd_setup 

#loading data into mongodb 
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y 

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexof("mydb")')

if [ $INDEX -le 0 ]; then 
     mongosh --host $MONGODB_HOST </app/db/master-data.js
     VALIDATE $? "loading products"
else 
    echo -e "$(date "+%y-%m-%d %H:%M:%S") | Product already loaded ... $Y SKIPPING $N"
fi 



