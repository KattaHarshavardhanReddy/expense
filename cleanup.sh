#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

src_dir=$1
dest_dir=$2
days=${3:-14} #if user is not giving no. of days we give 14 days by default

timestamp=$(date +%F-%H-%M-%S)
log_file="/tmp/log_cleaner_$timestamp.log"

echo " Script started at: $timestamp " 

log_msg() {
  echo -e "$1" | tee -a "$log_file"
}

USAGE(){
    echo -e "$R USAGE ERROR:: $N backup.sh <src_dir> <dest_dir> <days>"
    exit 1
}

if [ $# -lt 2 ]
then
USAGE 
echo  "You need to provide both <src_dir> and <dest_dir> to execute"

fi

# mkdir -p "$dest_dir"

  if [ ! -d "$src_dir" ]; then
    log_msg "${R}Source directory not found: $src_dir${N}"
    exit 1
  fi

    if [ ! -d "$dest_dir" ]; then
    log_msg "${R}Source directory not found: $dest_dir${N}"
    exit 1
  fi
