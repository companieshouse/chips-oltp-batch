#!/bin/bash

# sed command to add export to beginning of each line and quote values
env | sed 's/^/export /;s/=/&"/;s/$/"/' > /apps/oltp/env.variables

# set oltp user crontab
su -c 'crontab /apps/oltp/cron/crontab.txt' oltp

# Start cron
crond -n