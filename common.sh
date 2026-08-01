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
SCRIPT_DIR=$PWD 
START_TIME=$(date +%s)
$MONGODB_HOST=mongodb.bunnyone.online 
MYSQL_HOST=mysql.bunnyone.online

mkdir -p $LOGS_FOLDER

echo "$(date "+%y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script as root user access $N" | tee -a $LOGS_FILE
    exit 1
fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2  ... $M FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
       echo -e "$(date "+%y-%m-%d %H:%M:%S")  | $2   ... $G success $N" | tee -a $LOGS_FILE
    fi
 }

 nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disable Nodejs Default version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enable required module"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Install NodeJS"

    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing dependencies"

 }
 
 java_setup(){
    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Install maven"

    cd /app 
    mvn clean package &>>$LOGS_FILE
    VALIDATE $? "Installing and building $app_name"

    mv target/$app_name-1.0.jar $app_name.jar 
    VALIDATE $? "Installing and Renaming $app_name"
}

python_setup(){
    dnf install python3 gcc python3-devel -y
    VALIDATE $? "downloading python"

    cd /app 
    pip3 install -r requirements.txt &>>$LOGS_FILE
    VALIDATE $? "installing dependencies"
}


 app_setup(){
    #creating system user 
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then 
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "creating system user"
    else 
         echo -e "Roboshop user already exist... $Y SKIPPING $N"
    fi 
     
     #downloading the app 
    mkdir -p /app 
    VALIDATE "creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name code"

    cd /app 
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code" 

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Uzip $app_name code"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Created systemctl services"


   systemctl daemon-reload 
   systemctl enable $app_name &>>$LOGS_FILE
   systemctl start $app_name
   VALIDATE $? "Starting and enabling $app_name"
  }

  app_restart(){
    systemctl restart $app_name 
    VALIDATE $? "Restarting $app_name" 
  }

 print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "Script executed in: $ $TOTAL_TIME seconds"
 }


