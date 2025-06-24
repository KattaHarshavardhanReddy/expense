#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[34m"
N="\e[0m"

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo -e "$R u r not root user $N"
    exit 1
fi

MYSQLINSTALL(){
if [ $? -ne 0 ]
    then
        echo -e " installation $R Failed $N"
    else
        echo -e "installation $G success $N"
    fi
}


dnf list installed mysql
if [ $? -ne 0 ]
then
    dnf install mysql -y
    MYSQLINSTALL $? "installing mysql"
else
    echo -e " $Y MYsql is already installed $N"
fi