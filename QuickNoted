# IaaC-Repo
Quick Help Rough note

for i in `cat INSTANCE_NAME.txt  | egrep -v "vm-108" | awk '{print $1}'`
do
#echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text >> volume.txt 
#echo "Instance details end $i"
done
### working###
for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
VOL_ID=`aws ec2 describe-instances --instance-ids $i --filters "Name=tag:snapshotbackup,Values=true" --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text`
INS_NAME=`cat INSTANCE_NAME.txt  | egrep -w $i | awk '{print $2}'`
VOL_ID_1=`cat $VOL_ID | awk '{print $1}'`
SNAP_ID_VOL=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOL_ID_1 --query "Snapshots[?(StartTime>='2023-10-04')].[SnapshotId]" --output text`
echo $i, $INS_NAME, $VOL_ID, $SNAP_ID_VOL >> INS_VOL_SNAPID.txt
done


for i in `cat INSTANCE_NAME.txt | egrep -v "vm-108|ansible|snapshot|internal" | awk '{print $1}'`
do
VOL_ID=`aws ec2 describe-instances --instance-ids $i --filters "Name=tag:snapshotbackup,Values=true" --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text`
INS_NAME=`cat INSTANCE_NAME.txt  | egrep -w $i | awk '{print $2}'`
VOL_ID_1="$VOL_ID | awk '{print $1}'"
SNAP_ID_VOL=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOL_ID_1 --query "Snapshots[?(StartTime>='2023-09-30')].[SnapshotId]" --output text`
echo $i, $INS_NAME, $VOL_ID, $SNAP_ID_VOL >> INS_VOL_SNAPID.txt
done



### working###


for v in `cat volume.txt  | awk '{print $1}'`
do
echo "volume details details start $v"
aws ec2 describe-snapshots --filters Name=volume-id,Values=$v --query "Snapshots[?(StartTime>='2023-10-04')].[SnapshotId]" --output text
echo "Instance details end $v"
done

snapshotbackup true

for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --filters "Name=tag:snapshotbackup,Values=true" --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text >> volume.txt 
echo "Instance details end $i"
done


aws ec2 describe-instances --filters "Name=snapshotbackup,Values=true"
aws ec2 describe-instances --filters "Name=tag:snapshotbackup,Values=true" 
	
	aws ec2 describe-instances --filters "Name=tag-value,Values=snapshotbackup"
###aws ec2 describe-instances --filters Name=tag-key,Values=Name --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' --output text > INSTANCE_NAME.txt

############### TEST Case ###############3

#!/bin/bash
for i in `cat test.txt  | awk '{print $1}'`
do
        VOL_ID=`aws ec2 describe-instances --instance-ids $i --filters "Name=tag:snapshotbackup,Values=true" --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text >> volume.txt`
        INS_NAME=`cat test.txt  | egrep -w $i | awk '{print $2}'`
        echo $i, $INS_NAME, $VOL_ID  >> INS_VOL_SNAPID.txt
        for VOL_ID_1 in `cat $VOL_ID | awk '{print $1}'`
        do

        SNAP_ID_VOL=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOL_ID_1 --query "Snapshots[?(StartTime>='2023-10-04')].[SnapshotId]" --output text | head -1`
#       VOL_ID_1=`cat $VOL_ID | awk '{print $1}'`
#       SNAP_ID_VOL=`aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOL_ID_1 --query "Snapshots[?(StartTime>='2023-10-04')].[SnapshotId]" --output text`
        echo $i, $INS_NAME, $VOL_ID, $SNAP_ID_VOL >> INS_VOL_SNAPID.txt
done
done

######################

aws ec2 describe-instances --filters Name=tag-key,Values=Name --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' --output text | egrep "ec2|mci" > INSTANCE_NAME.txt

aws acm list-certificates --certificate-status "EXPIRED" | jq -r '.CertificateSummaryList[] | select(.status="EXPIRED") | .CertificateArn'  --output table

###########################

aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value,InstanceId,BlockDeviceMappings[*].Ebs.VolumeId]' --output text

for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
INS_NAME=`cat INSTANCE_NAME.txt | awk '{print $2}'`
INS_ID=$i

EBS_VOL_ID() {
aws ec2 describe-instances --instance-ids $i \
--query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output table
}


done

#########################3

for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
#echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output table
#echo "Instance details end $i"
done

###############
for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[?Key==`Name`].Value | [0],InstanceType,Platform,State.Name,PrivateIpAddress,Tags[?Key==`Name`].Value | [0],BlockDeviceMappings[*].Ebs.VolumeId]' --output table
echo "Instance details end $i"
done


################

for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId,InstanceId]' --output table
echo "Instance details end $i"
done

##############working ###
for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output table
echo "Instance details end $i"
done
##############working ###

for i in `cat INSTANCE_NAME.txt  | awk '{print $1}'`
do
echo "Instance details start $i"
aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]' --output text > volume.txt 
echo "Instance details end $i"
done

for v in `cat volume.txt  | awk '{print $1}'`
do
echo "volume details details start $v"
aws ec2 describe-snapshots --filters Name=volume-id,Values=$v --query "Snapshots[*].[SnapshotId]" --output text 
echo "Instance details end $v"
done


aws ec2 describe-snapshots --filters Name=volume-id,Values=vol-0479550a7bde9321a --query "Snapshots[?(StartTime>='2023-10-04')].[SnapshotId]"
aws ec2 describe-snapshots \
    # --owner-ids 012345678910 \
	
	--filters Name=volume-id,Values=vol-0479550a7bde9321a \
    --query "Snapshots[*].[SnapshotId]" \
    --query "Snapshots[?(StartTime<='2023-10-01')].[SnapshotId]"
	
aws ec2 describe-snapshots --filters Name=volume-id,Values=vol-0479550a7bde9321a --query "Snapshots[?(StartTime<='2023-10-01')].[SnapshotId]"


Snapshotbackup true
