#!/bin/sh

# run cron daemon in the background
cron && \ 
tail -f /home/nonroot/cron.log # watch the log file

# In production we can run a web server or other service here instead of tailing the log file