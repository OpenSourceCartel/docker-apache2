FROM jkirkby91/ubuntusrvbase:latest
MAINTAINER James Kirkby <james.kirkby@sonyatv.com>

# Install some packages
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --force-yes --fix-missing apache2 apache2-mpm-event libapache2-mod-fastcgi --fix-missing && \
apt-get remove --purge -y software-properties-common build-essential && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

# Copy global apache2 config
COPY confs/apache2/apache2.conf /etc/apache2/apache2.conf

# Set good permissions for logging files
RUN chmod -Rf 754 /var/log/apache2 && \
chown -R www-data:www-data /var/log/apache2

# Disable default site
RUN a2dissite 000-default

# Enable some apache mods
RUN a2enmod actions fastcgi alias rewrite macro

# Copy the php5-fpm mod conf to apache folders
COPY confs/apache2/conf-available/php5-fpm.conf /etc/apache2/conf-available/php5-fpm.conf

# Enable the fastcgi php5-fpm conf
RUN a2enconf php5-fpm

# Copy supervisor config to container
COPY confs/supervisord/supervisord.conf /etc/supervisord.conf

# Set permission for funny docker quirks
RUN usermod -u 1000 www-data && \
# this breaks access to a fastcgi conf stopping apache starting, so do a dutty fix
chown -Rf www-data:www-data /var/lib/apache2/fastcgi && \
chmod -Rf 754 /var/lib/apache2

# Expose Ports
EXPOSE 80

RUN curl -s https://gist.githubusercontent.com/jkirkby91/df5436ed5625f3c8e3648f402ac79a80/raw/4e130a53fb0f41632d966fb5accda06951054b14/start.sh -O /vagrant/start.sh

RUN chmod 777 /vagrant/start.sh

# Set entrypoint
CMD ["/bin/bash/, "/vagrant/start.sh"]
