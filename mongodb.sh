#!/bin/bash

source ./common.sh

check_root 

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing mongoDB server"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enable mongoDB"

systemctl start mongod 
VALIDATE $? "start mongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
VALIDATE $? "Allowing remote connections" 

systemctl restart mongod 
VALIDATE $? "Restarted MongoDB"

print_total_time















