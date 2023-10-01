#!/bin/bash
# Purpose:                 Create Cloudwatch Alarm metrics for CPU, Memory, Disk utilization & Node Health status
# Script:                  cloudwatch_alarm.sh
# How To Execute:          Run from AWS CloudShell prompt (or) Run aws configuration with Account detail
# Input variable Change:   Value required before executing this script Account ID, SNS Project Name, NOC Email ID
# Input Variable
ZONE_ID=ap-southeast-1
ACC_ID=`aws sts get-caller-identity --query "Account" --output text`
SNS_PRJ_NAME=<SNS_TOPIC_NAME_CREATED>        # ----> Keyin SNS Topic Name
ARN_UR="arn:aws:sns:$ZONE_ID:$ACC_ID:$SNS_PRJ_NAME"
SHRT_NAME=ec2                                # ----> Keyin Instance short name to filter
TIME_PERIOD_ALARM=300
DISK_1="/"
DISK_2="/var"
DISK_3="/home"
# Input Variable
# Define the CPU utilization Warning,High,Critical threshold for your alarms
CPU_THRESHOLD_WARNING=70
CPU_THRESHOLD_HIGH=80
CPU_THRESHOLD_CRITICAL=90
NODE_ALARM_THRESHOLD=0
RECUR_PERIOD=3
SEND_EMAIL_ID="YOUREMAIL@DOMAIN.com>

#Create SNS Topic add email subscribtion
CREATE_SNS() {
AWS_SNS_LST_BAU=`aws sns list-topics | jq -r '.Topics' | egrep $SNS_PRJ_NAME`
if [[ "$AWS_SNS_LST_BAU" -eq 0 ]]
then
aws sns create-topic --name $SNS_PRJ_NAME
aws sns subscribe --topic-arn arn:aws:sns:$ZONE_ID:$ACC_ID:$SNS_PRJ_NAME --protocol email --notification-endpoint $SEND_EMAIL_ID
else
exit 0
fi
}
CREATE_SNS

# Define the CPU utilization Warning,High,Critical threshold for your alarms
# Get all EC2 Instance ID in AWS compartment
aws ec2 describe-instances --filters Name=tag-key,Values=Name --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' --output text | egrep "ec2|mci" > INSTANCE_NAME.txt
## create a CloudWatch alarm for CPU, Memory, Disk Utilization threshold limit
CLOUDWATCH_ALARM_CPU() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt |  egrep -v "donot|clone|restore|discover|test"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm for WARNING CPU Utilization > Than $CPU_THRESHOLD_WARNING%
aws cloudwatch put-metric-alarm --alarm-name "CPUAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_WARNING" --alarm-description "CPU Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "CPUUtilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm for HIGH CPU Utilization HIGH > Than $CPU_THRESHOLD_HIGH%
aws cloudwatch put-metric-alarm --alarm-name "CPUAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_HIGH" --alarm-description "CPU Utilization Alarm $CPU_THRESHOLD_HIGH%" --actions-enabled --metric-name "CPUUtilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_HIGH --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm for CRITICAL CPU Utilization > Than $CPU_THRESHOLD_CRITICAL%
aws cloudwatch put-metric-alarm --alarm-name "CPUAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_CRITICAL" --alarm-description "CPU Utilization Alarm $CPU_THRESHOLD_CRITICAL%" --actions-enabled --metric-name "CPUUtilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_CRITICAL --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_MEMORY() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt |  egrep -v "donot|clone|restore|discover|test"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm for WARNING Memory Utilization > Than $CPU_THRESHOLD_WARNING%
aws cloudwatch put-metric-alarm --alarm-name "MemoryAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_WARNING" --alarm-description "Memory Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "Memory-Utilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm for HIGH Memory Utilization > Than $CPU_THRESHOLD_HIGH%
aws cloudwatch put-metric-alarm --alarm-name "MemoryAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_HIGH" --alarm-description "Memory Utilization Alarm $CPU_THRESHOLD_HIGH%" --actions-enabled --metric-name "Memory-Utilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_HIGH --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm for CRITICAL Memory Utilization > Than $CPU_THRESHOLD_CRITICAL%
aws cloudwatch put-metric-alarm --alarm-name "MemoryAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_CRITICAL" --alarm-description "Memory Utilization Alarm $CPU_THRESHOLD_CRITICAL%" --actions-enabled --metric-name "Memory-Utilization" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_CRITICAL --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_DISK_LINUX() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt |  egrep -v "donot|clone|restore|discover|test"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm Linux for WARNING Disk Utilization > Than $CPU_THRESHOLD_WARNING%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_WARNING" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Linux for WARNING Disk Utilization > Than $CPU_THRESHOLD_HIGH%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_HIGH" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_HIGH%" --actions-enabled --metric-name "Disk-Space-Utilization"  --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_HIGH --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Linux for CRITICAL Disk Utilization > Than $CPU_THRESHOLD_CRITICAL%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_CRITICAL" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_CRITICAL%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_CRITICAL --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_DISK_WINDOWS() {
# CloudWatch Alarm Windows for WARNING Disk Utilization > Than 80%
for INSTANCE_ID in `cat INSTANCE_NAME.txt |  egrep -v "donot|clone|restore|discover|test"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME-$CPU_THRESHOLD_WARNING" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_NODE() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt |  egrep -v "donot|clone|restore|discover|test"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm for Node Status
aws cloudwatch put-metric-alarm --alarm-name "NodeAlarm-$INSTANCE_NAME" --alarm-description "Node $INSTANCE_NAME is down alarm" --actions-enabled --metric-name "StatusCheckFailed_Instance" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $NODE_ALARM_THRESHOLD --comparison-operator "GreaterThanThreshold" --evaluation-periods 1 --treat-missing-data "missing" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_CPU
CLOUDWATCH_ALARM_MEMORY
CLOUDWATCH_ALARM_DISK_LINUX
CLOUDWATCH_ALARM_DISK_WINDOWS
CLOUDWATCH_ALARM_NODE
rm INSTANCE_NAME.txt
