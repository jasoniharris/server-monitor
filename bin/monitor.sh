#!/bin/bash

LOGFILEDIR="/home/htpc/server-monitor/logs"
TIMESTAMP=`date "+%d-%m-%Y"`
TIMESTAMPENTRY=`date "+%Y-%m-%d-%H%M%S"`
METRICSLOGFILE="${LOGFILEDIR}/${TIMESTAMP}-metrics.log"
UPTIMELOGFILE="${LOGFILEDIR}/${TIMESTAMP}-uptime.log"
SLEEP="10"
AWSCREDS="/home/htpc/.aws/credentials"
mkdir -p ${LOGFILEDIR}

export AWS_ACCESS_KEY_ID=`grep aws_access_key_id ${AWSCREDS} | cut -d" " -f3`
export AWS_SECRET_ACCESS_KEY=`grep aws_secret_access_key ${AWSCREDS} | cut -d" " -f3`
export AWS_DEFAULT_REGION=eu-west-2

load_metrics(){
    echo "Loading metrics"
    # echo "CPU MEM ARGS ${TIMESTAMPENTRY}" >> ${METRICSLOGFILE}
    echo "%CPU %MEM ARGS ${TIMESTAMPENTRY}" && ps -e -o pcpu,pmem,args --sort=pcpu | cut -d" " -f1-5 | tail >> ${METRICSLOGFILE}
}

load_uptime(){
    echo "Loading uptime"
    uptime | cut -d" " -f14-16 > ${UPTIMELOGFILE}
         
    }

check_logfile(){
    LOGFILE=$1
    if [[ ! -f $LOGFILE ]]
    then
        # Create daily log file
        echo "$LOGFILE created."
        touch ${LOGFILE}
    fi
}

process_uptime_metrics(){
    DATA=`uptime | cut -d" " -f14-16`
    CPU=`echo $DATA | cut -d" " -f1 | sed 's/,*$//g'`
    MEMORY=`echo $DATA | cut -d" " -f2 | sed 's/,*$//g'`

    echo "CPU = ${CPU}"

    echo "Publishing to cloudwatch"
    aws cloudwatch put-metric-data \
    --metric-name cpu-usage \
    --namespace "Custom" \
    --value ${CPU}
}

controller(){
    # check_logfile ${METRICSLOGFILE}
    # check_logfile ${UPTIMELOGFILE}
    
    # load_metrics
    load_uptime

    process_uptime_metrics

}

controller