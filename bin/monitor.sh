#!/bin/bash

AWSCREDS="/home/htpc/.aws/credentials"

export AWS_ACCESS_KEY_ID=`grep aws_access_key_id ${AWSCREDS} | cut -d" " -f3`
export AWS_SECRET_ACCESS_KEY=`grep aws_secret_access_key ${AWSCREDS} | cut -d" " -f3`
export AWS_DEFAULT_REGION=eu-west-2

process_cpu_metrics(){
    DATA=`uptime | cut -d" " -f14-16`
    CPU=`echo $DATA | cut -d" " -f1 | sed 's/,*$//g'`
    echo "CPU = ${CPU}"

    # Publish to Cloudwatch <metric-name> <metric-value>
    publish_to_cloudwatch "cpu-usage" ${CPU}
}

process_memory_metrics(){
    DATA=`free -m | tail -2 | head -1`
    MEMORY_USED=`echo ${DATA} | awk '{print $3}'`
    echo "MEMORY_USED = ${MEMORY_USED}"

    # Publish to Cloudwatch <metric-name> <metric-value>
    publish_to_cloudwatch "memory-usage" ${MEMORY_USED}
}

process_hdd_metrics(){
    DATA=`df -h | grep sdb2`
    HDD_CAPACITY_FREE=`echo ${DATA} | awk '{print $4}' | sed 's/G*$//g'`
    echo "HDD_CAPACITY_FREE = ${HDD_CAPACITY_FREE}"

    # Publish to Cloudwatch <metric-name> <metric-value>
    publish_to_cloudwatch "hdd-usage" ${HDD_CAPACITY_FREE}
}

publish_to_cloudwatch(){
    METRICNAME=$1
    METRICVALUE=$2

    echo "Publishing to cloudwatch"
    aws cloudwatch put-metric-data \
    --metric-name ${METRICNAME} \
    --namespace "Custom" \
    --value ${METRICVALUE}
}

controller(){
    process_cpu_metrics
    process_memory_metrics
    process_hdd_metrics
}

controller