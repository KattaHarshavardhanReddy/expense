#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

source_dir="/home/ec2-user/expense/app-logs/"
logs_folder="/var/log/expense-logs/"
logs_files="$(echo $0 | cut -d "." -f1)"
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
Log_Name="$logs_folder/$logs_files-$Timestamp.log"

echo " Script started at: $Timestamp " &>>$Log_Name

USERID=$(id -u)

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R u r not root user $N"
        exit 1
    fi
}

File_to_dlt=$(find $source_dir -name "*" -mtime +14)
echo " files deleted are : $File_to_dlt "