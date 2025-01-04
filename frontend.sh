#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
LOG_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FILE_NAME="$LOG_FOLDER/$LOG_FILE/$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ] 
    then
    echo -e "$2.....$R FAILURE"
    exit 1
    else
    echo -e "$2......$G SUCCESS"
    fi
}

CHECK_ROOT()
{
if [ $USERID -ne 0 ] 
then
echo "Display :Root id  Failure"
exit 1
else
echo "Display :Root id  Sucess"
fi
}
echo "script executed at : $TIMESTMP" &>>LOGS_FILE_NAME
dnf install nginx -y &>>LOGS_FILE_NAME

VALIDATE $? "install nginx"

systemctl enable nginx &>>LOGS_FILE_NAME
VALIDATE $? "Enable nginx"
systemctl start nginx &>>LOGS_FILE_NAME
VALIDATE $? "Start enginx"
rm -rf /usr/share/nginx/html/*
VALIDATE $? "remove html"
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "downloading code"

cd /usr/share/nginx/html
VALIDATE $? "Moving to directory"
unzip /tmp/frontend.zip
VALIDATE $? "unzipping the file"

systemctl restart nginx
VALIDATE $? "restart nginx"