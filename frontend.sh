#!/bin/bash

source ./common.sh

app_name=frontend
check_root 

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE "installing nginx"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx
VALIDATE "Enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Downloaded and unzip frontend"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx xonf file"

systemctl restart nginx 
VALIDATE $? " restart"

print_total_time

