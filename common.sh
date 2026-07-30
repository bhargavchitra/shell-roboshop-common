#!/bin/bash 


USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[37m"
N="\e[0m"
START_TIME=$(date +%s)

echo "$(date "+%y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script as root user access $N" | tee -a $LOGS_FILE
    exit 1
fi
}

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2  ... $M FAILURE $N" | tee -a $LOGS_FILE
        exit 1
  else
       echo -e "$(date "+%y-%m-%d %H:%M:%S")  | $2   ... $G success $N" | tee -a $LOGS_FILE
 fi
 }

 print_total_time(){
    END_TIME=$(date+%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $ $TOTAL_TIME seconds"
 }
