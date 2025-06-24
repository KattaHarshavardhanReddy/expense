#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[34m"
N="\e[0m"

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

CHECK_ROOT

MYSQLINSTALL(){
if [ $1 -ne 0 ]
    then
        echo -e " $2 installation $R Failed $N"
        exit 1
    else
        echo -e " $2 installation $G success $N"
    fi
}

dnf list installed mysql &>>$Log_Name
if [ $? -ne 0 ]
then
    dnf install mysql-server -y &>>$Log_Name
    MYSQLINSTALL $? "installing mysql-server" 
else
    echo -e " $Y Mysql-server is already installed $N"
fi

systemctl enable mysqld  &>>$Log_Name
MYSQLINSTALL $? "enabled mysql-server"

systemctl start mysqld &>>$Log_Name
MYSQLINSTALL $? "started mysql-server"

mysql_secure_installation --set-root-pass ExpenseApp@1 | tee -a &>>$Log_Name
MYSQLINSTALL $? "root password setup completed"
