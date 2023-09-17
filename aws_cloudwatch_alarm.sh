#!/bin/bash
# Purpose:                 Create Cloudwatch Alarm metrics for CPU, Memory, Disk utilization & Node Health status
# Script:                  cloudwatch_alarm.sh
# How To Execute:          Run from AWS CloudShell prompt (or) Run aws configuration with Account detail
# Input variable Change:   Value required before executing this script Account ID, SNS Project Name, NOC Email ID
# Input Variable
ZONE_ID=ap-southeast-1
ACC_ID=<AWS_ACCOUNT_ID>
SNS_PRJ_NAME=<SNS_TOPIC_NAME_CREATED>
ARN_UR="arn:aws:sns:$ZONE_ID:$ACC_ID:$SNS_PRJ_NAME"
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
# Define the CPU utilization Warning,High,Critical threshold for your alarms
# Get all EC2 Instance ID in AWS compartment
aws ec2 describe-instances --filters Name=tag-key,Values=Name --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' --output text > INSTANCE_NAME.txt
## Create a CloudWatch alarm for CPU Metrics threshold limits
CLOUDWATCH_ALARM_CPU() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt | egrep "mccy" | egrep -v "donot|clone|restore|discover"`
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
## Create a CloudWatch alarm for Memory Metrics threshold limits
CLOUDWATCH_ALARM_MEMORY() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt | egrep "mccy" | egrep -v "donot|clone|restore|discover"`
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
## Create a CloudWatch alarm for Disk Utilization Linux Metrics threshold limits
CLOUDWATCH_ALARM_DISK_LINUX() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt | egrep "mccy" | egrep -v "donot|clone|restore|discover"`
do
for DISK_PATH in $DISK_1 $DISK_2 $DISK_3
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm Linux for WARNING Disk Utilization > Than $CPU_THRESHOLD_WARNING%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_$DISK_PATH-$CPU_THRESHOLD_WARNING" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "Disk-Space-Utilization" --disk-path "$DISK_PATH" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Linux for HIGH Disk Utilization > Than $CPU_THRESHOLD_HIGH%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_$DISK_PATH-$CPU_THRESHOLD_HIGH" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_HIGH%" --actions-enabled --metric-name "Disk-Space-Utilization" --disk-path "$DISK_PATH" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_HIGH --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Linux for CRITICAL Disk Utilization > Than $CPU_THRESHOLD_CRITICAL%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_$DISK_PATH-$CPU_THRESHOLD_CRITICAL" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_CRITICAL%" --actions-enabled --metric-name "Disk-Space-Utilization" --disk-path "$DISK_PATH" --statistic "Average" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_CRITICAL --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
done
}
## Create a CloudWatch alarm for Windows Disk Utilization Metrics threshold limits
CLOUDWATCH_ALARM_DISK_WINDOWS() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt | egrep "mccy" | egrep -v "donot|clone|restore|discover"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm Windows for WARNING Disk Utilization > Than $CPU_THRESHOLD_WARNING%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_C_DRIVE-$CPU_THRESHOLD_WARNING" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_WARNING%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --objectname "LogicalDisk" --instance "C:" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_WARNING --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Windows for HIGH Disk Utilization > Than $CPU_THRESHOLD_HIGH%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_C_DRIVE-$CPU_THRESHOLD_HIGH" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_HIGH%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --objectname "LogicalDisk" --instance "C:" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_HIGH --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
# CloudWatch Alarm Windows for CRITICAL Disk Utilization > Than $CPU_THRESHOLD_CRITICAL%
aws cloudwatch put-metric-alarm --alarm-name "DiskAlarm-$INSTANCE_NAME_C_DRIVE-$CPU_THRESHOLD_CRITICAL" --alarm-description "Disk Utilization Alarm $CPU_THRESHOLD_CRITICAL%" --actions-enabled --metric-name "Disk-Space-Utilization" --statistic "Average" --objectname "LogicalDisk" --instance "C:" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $CPU_THRESHOLD_CRITICAL --comparison-operator "GreaterThanThreshold" --evaluation-periods $RECUR_PERIOD --treat-missing-data "breaching" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
## Create a CloudWatch alarm for Linux File System Utilization Metrics threshold limits
CLOUDWATCH_ALARM_NODE() {
for INSTANCE_ID in `cat INSTANCE_NAME.txt | egrep "mccy" | egrep -v "donot|clone|restore|discover"`
do
INSTANCE_NAME=`cat INSTANCE_NAME.txt | egrep -w $INSTANCE_ID | awk '{print $2}'`
# CloudWatch Alarm for Node Status
aws cloudwatch put-metric-alarm --alarm-name "NodeAlarm-$INSTANCE_NAME" --alarm-description "Node $INSTANCE_NAME is down alarm" --actions-enabled --metric-name "StatusCheckFailed_Instance" --namespace "AWS/EC2" --statistic "Average" --period $TIME_PERIOD_ALARM --threshold $NODE_ALARM_THRESHOLD --comparison-operator "GreaterThanThreshold" --evaluation-periods 1 --treat-missing-data "missing" --dimensions "Name=InstanceID,Value=$INSTANCE_ID" --alarm-actions "$ARN_UR"
done
}
CLOUDWATCH_ALARM_CPU
CLOUDWATCH_ALARM_MEMORY
CLOUDWATCH_ALARM_DISK_LINUX
CLOUDWATCH_ALARM_NODE
rm INSTANCE_NAME.txt
