#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

source_dir=$1
dest_dir=$2
days=${3:-14} #if user is not giving no. of days we give 14 days by default

timestamp=$(date +%F-%H-%M-%S)
log_file="/tmp/log_cleaner_$timestamp.log"

echo " Script started at: $timestamp " &>>$Log_Name

log_msg() {
  echo -e "$1" | tee -a "$log_file"
}

validate_input() {
  if [ -z "$src_dir" ] || [ -z "$archive_dir" ]; then
    log_msg "${R}USAGE: $0 <log_dir> <archive_dir> [days]${N}"
    exit 1
  fi
}
