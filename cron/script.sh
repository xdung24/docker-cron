#!/bin/sh
me=$(basename "$0")
echo "Hello world from ${me} with user $(whoami) at $(date)" >> cron.log
