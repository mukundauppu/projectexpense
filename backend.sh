

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

dnf module disable nodejs -y &>>LOGS_FILE_NAME
VALIDATE $? " Diable node js"
dnf module enable nodejs:20 -y &>>LOGS_FILE_NAME
VALIDATE $? "Enable nodejs"
dnf install nodejs -y &>>LOGS_FILE_NAME
VALIDATE $? "Install node js"
id expense &>>LOGS_FILE_NAME
if [ $? -ne 0 ]
then
 useradd expense &>>LOGS_FILE_NAME
 VALIDATE $?
 else
 echo -e "already exiists $Y ...Skipping"
 fi

mkdir -p /app &>>LOGS_FILE_NAME
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGS_FILE_NAME
cd /app &>>LOGS_FILE_NAME
rm -rf /app/* &>>LOGS_FILE_NAME
unzip /tmp/backend.zip &>>LOGS_FILE_NAME
cd /app &>>LOGS_FILE_NAME
npm install &>>LOGS_FILE_NAME
cp /root/projectexpense/backend.service /etc/systemd/system/backend.service 
systemctl daemon-reload
systemctl start backend
systemctl enable backend
dnf install mysql -y
VALIDATE $? "Install mysql client "

mysql -h mysql.mukunda.store -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "Setting up the transactions and tables"

systemctl restart backend

