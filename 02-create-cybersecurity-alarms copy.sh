#!/bin/bash
###################################################################################################################################
# THIS SCRIPT IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
###################################################################################################################################

###################################################################################################################################
## Date        Modifier         		Description
## ----------  --------------------  	----------------------------------------------------------------------------------------------------
## 2023-10-09  Ramakrishnan Solai K     Created to automate the CTS AWS Incident Playbook creation.
####################################################################################################################################

# File Name:	02-create-Cybersecurity-alarms.sh
# Setup logging
SCRIPTBASE=$(dirname ${0})
SCRIPTNAME=$(basename ${0%.sh})
EXECTIME=$(date +%F_%H.%M.%S%Z)
LOGDIR=${SCRIPTBASE}/logs
LOGFILE=${LOGDIR}/exec_${SCRIPTNAME}_${EXECTIME}.log
mkdir -p ${LOGDIR}
exec > $LOGFILE 2>&1

# Set the AWS Region to Singapore
AWS_REGION=ap-southeast-1
ACC_ID=`aws sts get-caller-identity --query "Account" --output text`

# Get Cloudtrail Log name
log_group_name=`aws logs describe-log-groups  --log-group-name-pattern "^aws-cloudtrail-logs*" --query 'logGroups[].logGroupName[]' --output text`

# Log every commands
set -x

# Variables
#log_group_name="aws-cloudtrail-logs-278506630753-b4ca076e"
agency_prefix="CS-UAT"
cybersecurity_response_plan_arn="arn:aws:ssm-incidents::$ACC_ID:response-plan/Cybersecurity-Response-Plan"

###################################################################################################################################
# Task 05: Create all Cybersecurity metrics and alarms
###################################################################################################################################
CREATE_ALL_CYBERSECURITY_LOG_METRICS_ALARM() {
echo "Creating all security metrics now..."
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name UnauthorizedAPICalls --metric-transformations metricName=UnauthorizedAPICallsEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.errorCode="*UnauthorizedOperation") || ($.errorCode="AccessDenied*")}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name IAMPolicyChanges --metric-transformations metricName=IAMPolicyChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name CloudtrailConfigChange --metric-transformations metricName=CloudtrailConfigChangeEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name ConsoleSignInFailure --metric-transformations metricName=ConsoleSignInFailureEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=ConsoleLogin) && ($.errorMessage="Failed authentication")}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name DisablingOrDeletionOfCMK --metric-transformations metricName=DisablingOrDeletionOfCMKEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name ChangesInS3BucketPolicy --metric-transformations metricName=ChangesInS3BucketPolicyEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name SecurityGroupChanges --metric-transformations metricName=SecurityGroupChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name NACLChanges --metric-transformations metricName=NACLChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name RouteTableChanges --metric-transformations metricName=RouteTableChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name NetworkGatewayChanges --metric-transformations metricName=NetworkGatewayChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name VPCChanges --metric-transformations metricName=VPCChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name AWSConfigChanges --metric-transformations metricName=AWSConfigChangesEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}'
aws logs put-metric-filter --log-group-name "${log_group_name}" --filter-name RootAccountUsage --metric-transformations metricName=RootAccountUsageEvent,metricNamespace=LogMetrics,metricValue=1,defaultValue=0 --filter-pattern '{$.userIdentity.type="Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !="AwsServiceEvent"}'
}
CREATE_ALL_CYBERSECURITY_LOG_METRICS_ALARM

echo "Creating all security alarms now..."
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - UnauthorizedAPICallsEvent" --metric-name UnauthorizedAPICallsEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - IAMPolicyChangesEvent" --metric-name IAMPolicyChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - CloudtrailConfigChangeEvent" --metric-name CloudtrailConfigChangeEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - ConsoleSignInFailureEvent" --metric-name ConsoleSignInFailureEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - DisablingOrDeletionOfCMKEvent" --metric-name DisablingOrDeletionOfCMKEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - ChangesInS3BucketPolicyEvent" --metric-name ChangesInS3BucketPolicyEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - SecurityGroupChangesEvent" --metric-name SecurityGroupChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - NACLChangesEvent" --metric-name NACLChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - RouteTableChangesEvent" --metric-name RouteTableChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - NetworkGatewayChangesEvent" --metric-name NetworkGatewayChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - VPCChangesEvent" --metric-name VPCChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - AWSConfigChangesEvent" --metric-name AWSConfigChangesEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1
aws cloudwatch put-metric-alarm --alarm-name "${agency_prefix} - RootAccountUsageEvent" --metric-name RootAccountUsageEvent --namespace LogMetrics --statistic Sum --period 300 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --alarm-actions "${cybersecurity_response_plan_arn}" --evaluation-periods 1

# Stop logging every commands
set +x