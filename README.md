# docker-cron
An example of running cron job in a docker container

## Note

Using command `crontab -e` will modify cronjob.

When running with root user or sudoer, it will modify /etc/cron.d/root, so you will need to add more argument `user` to cron job
The job will be like 
* * * * * <user_here> /script.sh

When running with nonroot user, it will modify /var/spool/cron/crontabs/nonroot, you don't need to specify the user
The job will be like 
* * * * * /script.sh

cron daemon can be either start as a service 
`service cron start`
or 
`cron` to run as normal process

You will need to monitor cron proccess and restart it manually, if you don't run it as a service
