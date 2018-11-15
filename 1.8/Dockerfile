FROM haproxy:1.8


COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY rsyslog.conf /etc/rsyslog.conf
# Install rsyslog
RUN apk upgrade --update && apk add bash ca-certificates rsyslog && mkdir -p /etc/rsyslog.d/ && touch /var/log/haproxy.log && ln -sf /dev/stdout /var/log/haproxy.log

# 1. Create a system group and user to be used by HAProxy.
# 2. make sure docker-entrypoint.sh can execute
# 3. backup default default config for reference
# 4. need to create a directory for stats socket
# 5. Need to create a directory for HAProxy to be able to `chroot`.
#    This is a security measurement.
#    Refer to http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#chroot.
RUN groupadd haproxy && useradd -g haproxy haproxy && chmod +x /docker-entrypoint.sh && cp /usr/local/etc/haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.org && mkdir /run/haproxy && mkdir /var/lib/haproxy

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
