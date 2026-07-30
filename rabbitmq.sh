#!/bin/bash

source ./common.sh

app_name=rabbitmq.sh
check_root 

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Added rabbitmq repo"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "installing rabbitmq-server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
systemctl start rabbitmq-server
VALIDATE $? "Enabled and start"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Created user and given permissions"

print_total_time