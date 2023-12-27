#!/bin/bash
###################################################################################################################################
# THIS SCRIPT IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
###################################################################################################################################

###################################################################################################################################
## Date        Modifier         	 Description
## ----------  --------------------  ----------------------------------------------------------------------------------------------------
## 2023-10-09  Ramakrishnan Solai K  Created to automate the CTS AWS Incident Playbook creation.
####################################################################################################################################
# File Name:	01-create-incident-contacts-plans.sh
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

# Contacts Variables
c1_email="l1_cyber_monitoring@example.com"
c2_email_atfm="l2_cyber_monitoring@example.com"
c2_email_ts="l2_cyber_lead@example.com"
c3_email_siro="l3_cyber_manager@example.com"
s1_email="l1_sa_monitoring@example.com"
s2_email_atfm="l2_sa_monitoring@example.com"
s2_email_ts="l2_sa_lead@example.com"
s3_email_tsm="l3_sa_manager@example.com"

c1_name="Cybersecurity Incident Level 1 Monitoring"
c2_name_atfm="Cybersecurity Incident Level 2"
c2_name_ts="Cybersecurity Incident Level 2 TS"
c3_name_siro="Cybersecurity Incident Level 3"
s1_name="Svc Availability Incident Level 1 Monitoring"
s2_name_atfm="Svc Availability Incident Level 2"
s2_name_ts="Svc Availability Incident Level 2 TS"
s3_name_tsm="Svc Availability Incident Level 3"

###################################################################################################################################
# Task 02: Create all contacts
###################################################################################################################################
echo "Creating cybersecurity contacts now..."
c1=$(aws ssm-contacts create-contact --alias "cybersecurity-incident-level-1-responder" --display-name "Cybersecurity Incident Level 1 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)
c2=$(aws ssm-contacts create-contact --alias "cybersecurity-incident-level-2-responder" --display-name "Cybersecurity Incident Level 2 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)
c3=$(aws ssm-contacts create-contact --alias "cybersecurity-incident-level-3-responder" --display-name "Cybersecurity Incident Level 3 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)

echo "Creating cybersecurity contact channels now..."
cc1=$(eval "aws ssm-contacts create-contact-channel --contact-id "${c1}" --name \""${c1_name}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${c1_email}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
cc2atfm=$(eval "aws ssm-contacts create-contact-channel --contact-id "${c2}" --name \""${c2_name_atfm}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${c2_email_atfm}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
cc2ts=$(eval "aws ssm-contacts create-contact-channel --contact-id "${c2}" --name \""${c2_name_ts}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${c2_email_ts}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
cc3siro=$(eval "aws ssm-contacts create-contact-channel --contact-id "${c3}" --name \""${c3_name_siro}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${c3_email_siro}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)

echo "Update cybersecurity contact plans now..."
# c1 
eval "aws ssm-contacts update-contact --contact-id "${c1}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${cc1}\",    \
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

# c2
eval "aws ssm-contacts update-contact --contact-id "${c2}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${cc2atfm}\",\
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                },                                          \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${cc2ts}\",  \
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

# c3
eval "aws ssm-contacts update-contact --contact-id "${c3}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${cc3siro}\",\
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

echo "Creating service availability contacts now..."
s1=$(aws ssm-contacts create-contact --alias "service-availability-incident-level-1-responder" --display-name "Service Availability Incident Level 1 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)
s2=$(aws ssm-contacts create-contact --alias "service-availability-incident-level-2-responder" --display-name "Service Availability Incident Level 2 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)
s3=$(aws ssm-contacts create-contact --alias "service-availability-incident-level-3-responder" --display-name "Service Availability Incident Level 3 Responder" --type PERSONAL --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)

echo "Creating service availability contact channels now..."
sc1=$(eval "aws ssm-contacts create-contact-channel --contact-id "${s1}" --name \""${s1_name}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${s1_email}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
sc2atfm=$(eval "aws ssm-contacts create-contact-channel --contact-id "${s2}" --name \""${s2_name_atfm}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${s2_email_atfm}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
sc2ts=$(eval "aws ssm-contacts create-contact-channel --contact-id "${s2}" --name \""${s2_name_ts}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${s2_email_ts}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)
sc3tsm=$(eval "aws ssm-contacts create-contact-channel --contact-id "${s3}" --name \""${s3_name_tsm}"\" --type EMAIL --delivery-address '{\"SimpleAddress\": \""${s3_email_tsm}"\"}'" | grep -i "ContactChannelArn" | cut -d'"' -f4)

echo "Update service availability contact plans now..."
# s1 
eval "aws ssm-contacts update-contact --contact-id "${s1}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${sc1}\",    \
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

# s2
eval "aws ssm-contacts update-contact --contact-id "${s2}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${sc2atfm}\",\
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                },                                          \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${sc2ts}\",  \
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

# s3
eval "aws ssm-contacts update-contact --contact-id "${s3}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":1,                        \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ChannelTargetInfo\":{                 \
                                        \"ContactChannelId\":\"${sc3tsm}\", \
                                        \"RetryIntervalInMinutes\":0        \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "
     
###################################################################################################################################
# Task 03: Create escalation plans
###################################################################################################################################
echo "Creating cybersecurity plan now..."
CREATE_CYBERSEC_PLAN=$(aws ssm-contacts create-contact --alias "cybersecurity-incident-escalation-plan" --display-name "Cybersecurity Incident Escalation Plan" --type ESCALATION --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)

echo "Update cybersecurity escalation plan now..."
eval "aws ssm-contacts update-contact --contact-id "${CREATE_CYBERSEC_PLAN}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":30,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${c1}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        },                                                  \
                        {                                                   \
                            \"DurationInMinutes\":30,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${c2}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        },                                                  \
                        {                                                   \
                            \"DurationInMinutes\":0,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${c3}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

echo "Creating service availability plan now..."
CREATE_SERVICE_AVAIL_PLAN=$(aws ssm-contacts create-contact --alias "service-availability-incident-escalation-plan" --display-name "Service Availability Incident Escalation Plan" --type ESCALATION --plan '{"Stages": []}' | grep -i "ContactArn" | cut -d'"' -f4)

echo "Update service availability plan now..."
eval "aws ssm-contacts update-contact --contact-id "${CREATE_SERVICE_AVAIL_PLAN}" --plan           \
                '{                                                          \
                    \"Stages\":[                                            \
                        {                                                   \
                            \"DurationInMinutes\":30,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${s1}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        },                                                  \
                        {                                                   \
                            \"DurationInMinutes\":30,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${s2}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        },                                                  \
                        {                                                   \
                            \"DurationInMinutes\":0,                       \
                            \"Targets\":[                                   \
                                {                                           \
                                    \"ContactTargetInfo\":{                 \
                                        \"ContactId\":\"${s3}\",            \
                                        \"IsEssential\":true                \
                                    }                                       \
                                }                                           \
                            ]                                               \
                        }                                                   \
                    ]                                                       \
                }'                                                          \
     "

###################################################################################################################################
# Task 04: Create response plans
###################################################################################################################################
echo "Creating cybersecurity response plan now..."
aws ssm-incidents create-response-plan --name "Cybersecurity-Response-Plan" --display-name "Cybersecurity" --engagements "${CREATE_CYBERSEC_PLAN}" --incident-template '{"impact": 2,"title":"Cybersecurity Incident"}' 

echo "Creating service availability response plan now..."
aws ssm-incidents create-response-plan --name "Service-Availability-Response-Plan" --display-name "Service Availability" --engagements "${CREATE_SERVICE_AVAIL_PLAN}" --incident-template '{"impact": 2,"title":"Service Availability Incident"}' 

# Stop logging every commands
set +x