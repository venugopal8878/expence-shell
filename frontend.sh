#!/bin/bash


# Logs_folder="/var/logs/expence"
# script_name=$(echo $0 | cut -d "." fi)
# TIMESTAMP=$(date +"%d-%m-%YYY-%h-%m-%s")
# log_file=$Logs_folder/$script_name-$timestamp.log
# mkdir -p $Logs_folder

userid=$(id -u)

R="/e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [$? -ne o]
    then 
      echo -e "$R plese run the script with root prevelages $n" 3 | tee -q $log_file
      exit 1
    fi
}


Validate(){
    if [ $1 -ne 0]
    then 
      echo -e " $1 is $R not sucessfull $2 is not installed please check once$N" # | tee -a $log_file
      exit 1
    else
      echo -e  "$1 is $Y suceessfull $2 is installed$N" #| tee -a $log_file
    fi
}

echo "script started executing at:$(date) " #&>>$log_file

check_root()

dnf install nginx -y &>>$log_file
validate $? "installing ngnix"

systemctl start nginx &>>$log_file
validate $? "stary nginx"

systemctl enable nginx &>>$log_file
validate $? "enable nginx"

rm -rf /usr/share/nginx/html/* &>>$log_file
validate $? "removing default directory"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$log_file
valiadate $? "downloadubg code"

cd /user/share/nginx/html
unzip /temp/front.zip
Validate $? "unsxipiing the file"


cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$log_file
validate ?? "ingnix re started"
