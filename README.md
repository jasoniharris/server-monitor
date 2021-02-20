# server-monitor
Monitor resource consumption of Linux based server
## Description
This is a simple BASH utility which is designed to collect performance stats from your system. This includes:
* 1/ CPU average
* 2/ Memory used
* 3/ HDD space available

This list will be expanded as the usecase demands.

The utility is written in BASH, managed via a daemon service conf/server-monitor.service. This is accompanied via a service timer conf/server-monitor.timer which controls the execution. Yes, you could use CRON, but a daemon service is better :) 

The utility requires an AWS account to be configured. Preferably under the same user account you plan to execute the utility from. The required values are read and stored at runtime.

# Pre-requisites
Create an AWS Account with a user that has permissions to publish to Amazon CloudWatch.

# Usage
Install onto your system. Check out the bin/deploy.sh for a simple scp deployment. 
After deployment, reload the service daemon
```sudo systemctl daemon-reload```

You can now start your server-monitor service
```service server-monitor start```

Check the status
```service server-monitor status```

Ensure your status started without error, and there is an entry for TriggeredBy: ● server-monitor.timer.

Now log into your AWS account, and load up Amazon CloudWatch. Follow this guide to create a new dashboard to display your metrics:
https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create_dashboard.html

Once completed, you can add new widgets to your dashboard. I suggest using Line graphs to start with. You can find the metrics published by this utility under Custom Namespaces > Custom 

# Feedback
If you have issues with this utility, please raise a GitHub issue.

# Contributing
Feel free to fork the repository and riase pull-request to be considered for main branch merging.


