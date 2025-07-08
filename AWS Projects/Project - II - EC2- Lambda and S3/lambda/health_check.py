import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.environ['INSTANCE_ID']

    status = ec2.describe_instance_status(InstanceIds=[instance_id])
    if status['InstanceStatuses']:
        state = status['InstanceStatuses'][0]['InstanceState']['Name']
        print(f"EC2 Instance {instance_id} is {state}")
    else:
        print(f"No status found for instance {instance_id}")

