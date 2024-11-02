FROM ubuntu:latest

#Install Cron
RUN apt-get update && apt-get -y install cron bash nano sudo htop

# Create a directory for the nonroot user
RUN mkdir /home/nonroot/

# create adm group if not exists
RUN groupadd -f adm

# create non root user
RUN useradd -m -g adm nonroot -s /bin/bash -d /home/nonroot -p $(openssl passwd -1 nonroot)

# Add nonroot user to the 'adm' group
RUN usermod -a -G adm nonroot

# Add nonroot user to the sudoers group
RUN usermod -aG sudo nonroot

# Change the ownership of the directory to the nonroot user
RUN chown -R nonroot:adm /home/nonroot/

# Add crontab file in the cron directory
COPY crontab-user /var/spool/cron/crontabs/nonroot

# Give execution rights on the cron job
RUN chmod 0777 /var/spool/cron/crontabs/nonroot

# Add crontab file in the cron directory
COPY crontab /etc/cron.d/nonroot

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/nonroot

# Delete both /etc/cron.deny and /etc/at.deny files.
RUN rm -f /etc/cron.deny /etc/at.deny

# Add nonroot user to /etc/cron.allow
RUN echo "nonroot" >> /etc/cron.allow

# Add nonroot user to /etc/at.allow
RUN echo "nonroot" >> /etc/at.allow

# Change group ownership to 'adm'
RUN chgrp adm /var/run

# Set permissions to allow group members to write
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

# Run the entrypoint script on container startup
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]