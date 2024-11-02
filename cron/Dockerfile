FROM ubuntu:latest

#Install Cron
RUN apt-get update && apt-get -y install cron bash nano sudo htop

# Create a group called 'crontab' if it does not exist
RUN groupadd -f crontab

# Create a directory for the nonroot user
RUN mkdir /home/nonroot/

# create adm group if not exists
RUN groupadd -f adm

# Overwrite cron init.d file
COPY cron-service /etc/init.d/cron
RUN chmod 0755 /etc/init.d/cron
RUN chown root:root /etc/init.d/cron
RUN chmod +x /etc/init.d/cron

# Add crontab for root user    
COPY crontab-root /etc/cron.d/root
RUN chmod 0644 /etc/cron.d/root
RUN crontab /etc/cron.d/root

# Create non root user
# Add nonroot user to the 'adm' & 'sudoer' group
# Change the ownership of the directory to the nonroot user
RUN useradd -m -g adm nonroot -s /bin/bash -d /home/nonroot -p $(openssl passwd -1 nonroot)
RUN usermod -a -G adm nonroot
RUN usermod -aG sudo nonroot
RUN chown -R nonroot:adm /home/nonroot/

# Add crontab for nonroot user
COPY crontab-user /var/spool/cron/crontabs/nonroot
RUN chmod 0777 /var/spool/cron/crontabs/nonroot
RUN chattr -i /var/spool/cron/crontabs/nonroot
RUN chown nonroot:crontab /var/spool/cron/crontabs/nonroot
RUN crontab -u nonroot /var/spool/cron/crontabs/nonroot

# Delete both /etc/cron.deny and /etc/at.deny files.
RUN rm -f /etc/cron.deny /etc/at.deny
RUN echo "nonroot" >> /etc/cron.allow
RUN echo "nonroot" >> /etc/at.allow

# Change group ownership to 'adm'
RUN chgrp adm /var/run
RUN chmod 777 /var/run

# Create cron service and start it
RUN service cron start

USER nonroot

# Change the working directory to the nonroot user's home directory
WORKDIR /home/nonroot/

# Copy the script to the nonroot user's home directory
COPY --chown=nonroot:adm script.sh script.sh

# Give execution rights on the script
RUN chmod +x script.sh

# Copy the entrypoint script
COPY --chown=nonroot:adm entrypoint.sh entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x entrypoint.sh

# Create the log file to be able to run tail
RUN touch cron.log

USER nonroot

# Copy the script file to the nonroot user's home directory
COPY --chown=nonroot:adm script.sh script.sh

# Give execution rights on the script
RUN chmod +x script.sh

# Run the entrypoint script on container startup
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]