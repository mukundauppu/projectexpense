


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

dnf install mysql-server -y &>>LOGS_FILE_NAME
VALIDATE $? "Inatlling mysql"

systemctl enable mysqld &>>LOGS_FILE_NAME
VALIDATE $? "Enabling mysql server"

systemctl start mysqld &>>LOGS_FILE_NAME
VALIDATE $? "Start mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGS_FILE_NAME
VALIDATE $? "Root password setting"




