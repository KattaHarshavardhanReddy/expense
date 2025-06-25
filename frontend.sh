#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

logs_folder="/var/log/expense-logs/"
logs_files="$(echo $0 | cut -d "." -f1)"
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
Log_Name="$logs_folder/$logs_files-$Timestamp.log"

mkdir -p $logs_folder

echo " Script started at: $Timestamp " &>>$Log_Name

USERID=$(id -u)

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R u r not root user $N"
        exit 1
    fi
}

CHECK_ROOT



FRONTEND(){
    if [ $1 -ne 0 ]
    then
    echo -e " $2 installation $R Failed $N "
    exit 1
    else
    echo -e " $2 installation $G Success $N "
    fi
}

dnf install nginx -y 
FRONTEND $? "Install nginx"

systemctl enable nginx
FRONTEND $? "enable nginx"

systemctl start nginx
FRONTEND $? "start nginx"

rm -rf /usr/share/nginx/html/*
FRONTEND $? "Remove default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
FRONTEND $? "download frontend content"

cd /usr/share/nginx/html
FRONTEND $? "moving to html directory"

unzip /tmp/frontend.zip
FRONTEND $? "unzip the files"

systemctl restart nginx
FRONTEND $? "restart the server"

