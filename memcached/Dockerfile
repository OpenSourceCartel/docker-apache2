FROM jkirkby91/ubuntusrvbase:latest
MAINTAINER James Kirkby <james.kirkby@sonyatv.com>

# Install packages specific to our project
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install memcached -y --force-yes --fix-missing && \
apt-get remove --purge -y software-properties-common build-essential  && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

# Port to expose (default: 11211)
EXPOSE 11211

COPY confs/apparmor/memcached.conf /etc/apparmor/memcached.conf

COPY confs/supervisord/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]