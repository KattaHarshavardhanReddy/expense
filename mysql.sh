#!/bin/bash

USERID=$(id -u)

if [$? -ne 0 ]
then
    echo "u r not root user"
    exit 1
fi

# R="/e[31m"
# G="/e[32m"
# Y="/e[34m"
# N="/e[0m"

dnf install mysql -y
if [ $? -ne 0 ]
then
    echo "install mysql"
else
    echo "mysql already installed"
fi