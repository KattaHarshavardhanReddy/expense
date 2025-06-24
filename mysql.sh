#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "u r not root user"
    exit 1
fi

# R="/e[31m"
# G="/e[32m"
# Y="/e[34m"
# N="/e[0m"

dnf list installed mysql
if [ $? -ne 0 ]
then
    dnf install mysqll -y
    if [ $? -ne 0 ]
    then
        echo "installation Failed"
    else
        echo "installation success"
    fi
else
    echo " MYsql is already installed"
fi