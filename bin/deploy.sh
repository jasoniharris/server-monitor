#!/bin/bash

cd ../
scp -r bin conf htpc@htpc:/home/htpc/Projects/server-monitor
scp service-monitor.service service-monitor.timer htpc@htpc:/etc/systemd/system