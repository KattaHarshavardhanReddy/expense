#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
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

BACKEND(){
    if [ $1 -ne 0 ]
    then
    echo -e " $2 installation $R Failed $N "
    exit 1
    else
    echo -e " $2 installation $G Success $N "
    fi
}

# dnf module disable nodejsg -y &>>$Log_Name
# if [ $? -ne 0 ]
# then
# echo -e "node JS $R not disabled $N"
# exit 1
# else
# echo -e "node JS $G  disabled $N"
# fi

dnf module disable nodejs -y &>>$Log_Name
BACKEND $? "Disabling NodeJS"

dnf module enable nodejs:20 -y &>>$Log_Name
BACKEND $? "Enable nodeJS 20"

dnf install nodejs -y &>>$Log_Name
BACKEND $? "Installing new nodeJS"

id expense
if [ $? -ne 0 ]
then
useradd expense &>>$Log_Name
BACKEND $? "Adding user"
else
echo -e "User $Y  already exist ...skipping $N"
fi

mkdir -p /app &>>$Log_Name
BACKEND $? "Creating App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Log_Name
BACKEND $? "Download the application code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$Log_Name
BACKEND $? "Unzipping the file to app directory"

npm install &>>$Log_Name
BACKEND $? "Installing NPM dependensies"

cp /home/ec2-user/expense/backend.service /etc/systemd/system/backend.service

# installing my sql client

dnf install mysql -y &>>$Log_Name
BACKEND $? "Installing mysql client"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$Log_Name
BACKEND $? "Load Schema"

systemctl daemon-reload &>>$Log_Name
BACKEND $? "Load the service"

systemctl enable backend &>>$Log_Name
BACKEND $? "enable the service"

systemctl start backend &>>$Log_Name
BACKEND $? "Start the service"
