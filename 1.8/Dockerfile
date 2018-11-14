FROM haproxy:1.8


COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

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
