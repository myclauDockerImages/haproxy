#!/bin/bash
set -e
if [ "${HAPROXY_CONFIG_STRING}" != "$null" ]; then
 echo "${HAPROXY_CONFIG_STRING}" > /usr/local/etc/haproxy/haproxy.cfg
fi

readonly RSYSLOG_PID="/var/run/rsyslogd.pid"
rm -f $RSYSLOG_PID
rsyslogd




# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
