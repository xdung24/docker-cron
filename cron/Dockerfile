FROM ubuntu:latest

#Install Cron
RUN apt-get update && apt-get -y install bash nano sudo htop curl

# RUN apt-get -y install cron

WORKDIR /tmp

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
    SUPERCRONIC=cron

RUN curl -fsSL "$SUPERCRONIC_URL" -o "/tmp/${SUPERCRONIC}" \
&& echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
&& chmod +x "$SUPERCRONIC" \
&& mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
&& ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Create a group called 'crontab' 'adm' if it does not exist
RUN groupadd -f crontab && groupadd -f adm

# Add cronjob for root user    
COPY crontab-root /etc/cron.d/root
RUN chmod 0644 /etc/cron.d/root
# RUN crontab -u root /etc/cron.d/root

# Create a directory for the nonroot user
RUN mkdir /home/nonroot/

# Create non root user
# Add nonroot user to the 'adm' & 'sudoer' group
# Change the ownership of the directory to the nonroot user
RUN useradd -m -g adm nonroot -s /bin/bash -d /home/nonroot
RUN usermod -a -G adm nonroot
RUN usermod -aG sudo nonroot
RUN chown -R nonroot:adm /home/nonroot/

# Add cronjob for nonroot user
COPY crontab-nonroot /var/spool/cron/crontabs/nonroot
RUN chmod 0777 /var/spool/cron/crontabs/nonroot
RUN chattr -i /var/spool/cron/crontabs/nonroot
RUN chown nonroot:crontab /var/spool/cron/crontabs/nonroot
# RUN crontab -u nonroot /var/spool/cron/crontabs/nonroot

# Delete both /etc/cron.deny and /etc/at.deny files.
RUN rm -f /etc/cron.deny /etc/at.deny

# Create /etc/cron.allow and /etc/at.allow files
RUN echo "nonroot" >> /etc/cron.allow && echo "nonroot" >> /etc/at.allow

# Change group ownership to 'adm' and permissions to 777 for the /var/run directory
RUN chgrp adm /var/run && chmod 777 /var/run

# Change the permissions of the cron binary to allow execution by the 'adm' group
RUN chmod gu+rw /var/run && chmod gu+s "/usr/local/bin/${SUPERCRONIC}"

USER nonroot

# Change the working directory to the nonroot user's home directory
WORKDIR /home/nonroot/

# Copy the script to the nonroot user's home directory
COPY --chown=nonroot:adm script.sh script.sh

# Copy the entrypoint script
COPY --chown=nonroot:adm entrypoint.sh entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x entrypoint.sh && chmod +x script.sh

# Create the log file to be able to run tail
# We need to create it with nonroot user so both root and nonroot can write to it
RUN touch /home/nonroot/cron.log

# Copy the script file to the nonroot user's home directory
COPY --chown=nonroot:adm script.sh /script.sh

# Give execution rights on the script
RUN chmod +x /script.sh

# Run the entrypoint script on container startup
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]