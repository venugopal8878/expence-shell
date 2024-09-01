#!/bin/bash

logs_folder="/var/log/expence"
script_name=$(echo $0 | cut -d "." -f1)
time_stamp=$(date +%Y-%m-%d-%H-%M-%S)
logs_file=$logs_folder/$script_name_$timestamp.log
mkdir -p $logs_folder

userid=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

check_root(){
if [$? -ne o]

  echo -e "$R usre dont have root prevelages run with root user $N" |tee -a &>>$logs_file
  exit 1
fi
}
validate(){
   if [$1 -ne 0]
   then
     echo "$2 is $R failing installed $N" | tee -a $logs_file
    else
    echo "$2 is $Y sucessfully installed $N" | tee -a $logs_file

    fi
}

echo "script started excuting $(date)" | tee -a $logs_file

check_root

dnf  install mysql-server -y &>>$logs_file
validate $? "mysql server"

systemctl enable mysql-server  &>>$logs_file
validate $? "enable mysqlserver"

systemctl start mysql-server  &>>$logs_file
validate $? "started mysqlserver"

mysql -h mysql.venuportal.online -u root -pExpenseApp@1 -e 'show databases;' &>>$logs_file

if [$? -ne 0]
then 
   echo "root password is not set please check" &>>$logs_file
   mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi
