#!/bin/sh
me=$(basename "$0")
message="Hello world from ${me} with user $(whoami) at $(date)"
echo $message # log to stdout
echo $message >> /home/nonroot/cron.log # log to file
