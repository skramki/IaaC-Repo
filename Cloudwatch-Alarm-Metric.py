import boto3

# Initialize the AWS SDK
ec2_client = boto3.client('ec2')
cloudwatch_client = boto3.client('cloudwatch')
cloud_region=<enter your region>
cloudaccount_id=<enter your account ID>
cloudwatch_alarm_project_name=BAU_Demo_project

# Define the CPU utilization Warning,High,Critical threshold for your alarms
cpu_threshold_warning = 80.0
cpu_threshold_high = 90.0
cpu_threshold_critical = 95.0

# List all EC2 instances (modify the filters as needed)
instances = ec2_client.describe_instances(
    Filters=[
        {'Name': 'instance-state-name', 'Values': ['running']}
    ]
)

##INSTANCE_IDS=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text) ##Cloudshell
for reservation in instances['Reservations']:
    for instance in reservation['Instances']:
        # Get the instance ID
        instance_id = instance['InstanceId']

        # Create a CloudWatch alarm for CPUUtilization metric
     
        alarm_name_80 = f'CPUAlarm-{instance_id}-80'
        response = cloudwatch_client.put_metric_alarm(
            AlarmName=alarm_name_80,
            AlarmDescription='CPU Utilization Alarm 80%',
            ActionsEnabled=True,
            MetricName'CPUUtilization',
            Namespace='AWS/EC2',
            Statistic='Average',
            Period=300,
            Threshold=cpu_threshold_warning,
            ComparisonOperator='GreaterThanThreshold',
            EvaluationPeriods=3,
            TreatMissingData='breaching',
            Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
            AlarmActions='arn:aws:sns:{cloud_region}:{cloudaccount_id}:{cloudwatch_alarm_project_name}',
        )
        print(f'Created alarm {alarm_name_90} for instance {instance_id}')

        alarm_name_90 = f'CPUAlarm-{instance_id}-90'
        response = cloudwatch_client.put_metric_alarm(
            AlarmName=alarm_name_90,
            AlarmDescription='CPU Utilization Alarm 90%',
            ActionsEnabled=True,
            MetricName'CPUUtilization',
            Namespace='AWS/EC2',
            Statistic='Average',
            Period=300,
            Threshold=cpu_threshold_high,
            ComparisonOperator='GreaterThanThreshold',
            EvaluationPeriods=3,
            TreatMissingData='breaching',
            Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
            AlarmActions='arn:aws:sns:{cloud_region}:{cloudaccount_id}:{cloudwatch_alarm_project_name}',
        )
        print(f'Created alarm {alarm_name_90} for instance {instance_id}')
        
        alarm_name_95 = f'CPUAlarm-{instance_id}-95'
        response = cloudwatch_client.put_metric_alarm(
            AlarmName=alarm_name_95,
            AlarmDescription='CPU Utilization Alarm 95%',
            ActionsEnabled=True,
            MetricName'CPUUtilization',
            Namespace='AWS/EC2',
            Statistic='Average',
            Period=300,
            Threshold=cpu_threshold_critical,
            ComparisonOperator='GreaterThanThreshold',
            EvaluationPeriods=3,
            TreatMissingData='breaching',
            Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
            AlarmActions='arn:aws:sns:{cloud_region}:{cloudaccount_id}:{cloudwatch_alarm_project_name}',
        )
        print(f'Created alarm {alarm_name_95} for instance {instance_id}')
