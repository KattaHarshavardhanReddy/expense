#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

source_dir=$1
dest_dir=$2
days=${3:-14} # If user doesn't provide a value, default to 14 days

logs_folder="/home/ec2-user/expense-logs"
mkdir -p "$logs_folder"

script_name=$(basename "$0")
logs_files="${script_name%.*}"
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
Log_Name="$logs_folder/${logs_files}-${Timestamp}.log"

echo " Script started at: $Timestamp " &>>"$Log_Name"

VALIDATION(){
    if [ $1 -ne 0 ]; then
        echo -e " $2 $R Failed $N"
        exit 1
    else
        echo -e " $2 $G Success $N"
    fi
}

USAGE(){
    echo -e "$R USAGE ERROR::$N backup.sh <source_dir> <dest_dir> <days>"
    exit 1
}

# Check if arguments are provided
if [ $# -lt 2 ]; then
    USAGE
fi

# Validate source and destination directories
if [ ! -d "$source_dir" ]; then
    echo -e " $source_dir is $R not available $N"
    exit 1
fi

if [ ! -d "$dest_dir" ]; then
    echo -e " $dest_dir is $R not available $N"
    exit 1
fi

echo " Script is executing at: $Timestamp" &>>"$Log_Name"

# Find files older than $days and zip them
file=$(find "$source_dir" -type f -name "*.log" -mtime +$days)
if [ -n "$file" ]; then
    echo "Files are: $file"
    ZIP_file="$dest_dir/app-logs-$Timestamp.zip"
    find "$source_dir" -type f -name "*.log" -mtime +$days | zip -@ "$ZIP_file"
    if [ -f "$ZIP_file" ]; then
        echo "$file" | while read -r filepath; do
            echo "Deleting file: $filepath" &>>"$Log_Name"
            rm -rf "$filepath"
            echo "Deleted file: $filepath"
        done
    else
        echo -e " $R Error: Failed to create zip file $N"
        exit 1
    fi
else
    echo "No files in directory older than +$days"
fi
