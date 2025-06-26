#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

source_dir=$1
dest_dir=$2
days=${3:-14} #if user is not giving no. of days we give 14 days by default

logs_folder="/home/ec2-user/expense-logs/"
logs_files="$(echo $0 | cut -d "." -f1)"
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
Log_Name="$logs_folder/$logs_files-$Timestamp.log"

echo " Script started at: $Timestamp " &>>$Log_Name

VALIDATION(){
if [ $1 -ne 0 ]
    then
        echo -e " $2 installation $R Failed $N"
        exit 1
    else
        echo -e " $2 installation $G success $N"
    fi
}

USAGE(){
    echo -e "$R USAGE ERROR:: $N backup.sh <source_dir> <dest_dir> <days>"
    exit 1
}

mkdir -p /home/ec2-user/expense-logs/

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $source_dir ]
then
    echo -e " $source_dir is $R not available $N"
    exit 1
fi

if [ ! -d $dest_dir ]
then
    echo " $dest_dir is $R not availabl $N"
    exit 1
fi

echo " Script is excuting at : $TIMESTAMP" &>>$Log_Name

file=$(find $source_dir -type f -name "*.log" -mtime +$days)
if [ -n "$file" ]
then
    echo "Files are : $file"
    ZIP_file="$dest_dir/app-logs-$TIMESTAMP.zip"
    find $source_dir -type f -name "*.log" -mtime +$days | zip -@ "$ZIP_file"
    if [ -f $ZIP_file ]
    then
        echo "$file" | while read -r filepath
        do
            echo "deleting file: $filepath" &>> "$Log_Name"
            rm -rf "$filepath"
            echo "deleted file: $filepath"
        done
    else
        echo -e " $R Error :: fail to create Zip file $N "
        exit 1
    fi
else
    echo "no files in directory older that +$days"
fi