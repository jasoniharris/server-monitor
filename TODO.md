# TODO:
- Identify metric collection for CPU stats - DONE
- Determine collection intervaln - DONE
- Create collection mechanism, Python, Cron? - DONE
- Determine metric push mechanism, S3? - DONE
- Determine graphing mechanism, CloudWatch? - DONE
- Determine notification mechanism, SNS? - See Alerting feature
- Train ML to detect anomolies - IN PROGRESS
- Output current 'state' to logfiles for retrospective investigation

# Confirmed Features
## Alerting
This is a feature in-progress. Alerting will be handled via Amazon SNS to send an email to a registered address initally. This will be expanded to PagerDuty or Pushover which is an existing stack used by my other projects. Alert flags will be added to the logic to enable you to drive the alerting and on/off from this utility.