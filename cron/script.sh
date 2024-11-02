#!/bin/sh
echo "Hello world from script with user" $(whoami) " at " $(date) >> cron.log
