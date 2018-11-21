# haproxy
custom haproxy for testing

# HAProxy Version
`1.8-alpine`

# Reference
you can reference from:
https://github.com/docker-library/haproxy/tree/9da24940385e6178f987737305ff499734437c90/1.8
To read the Dockerfile of the haproxy base image and its docker-entrypoint.sh

For logging:
I reference from https://github.com/mminks/haproxy-docker-logging

if you run the image with these
```sh
rsyslogd: imklog: cannot open kernel log(/proc/kmsg): Operation not permitted.
rsyslogd: activation of module imklog failed [try http://www.rsyslog.com/e/2145 ]
```
You can ignore this and rsyslog will continue running as usual.
ref: https://www.loggly.com/docs/docker-syslog/

# Different from base
1. create default config
2. add logging with rsyslog
3. do these to make sure default config can work properly
  1. Create a system group and user to be used by HAProxy.
  2. make sure docker-entrypoint.sh can execute
  3. backup default default config for reference
  4. create a directory for stats socket
  5. create a directory for HAProxy to be able to `chroot`.
     This is a security measurement.
     Refer to http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#chroot.
4. allow you pass environment variable `HAPROXY_CONFIG_STRING` to override the default config, so that not need to mount just change the docker-compose or kubernetes yaml and restart the service its will work 
5. for how to use mutiple lines environment you can reference from ./docker-compose.yml

# To test locally or debug
1. git clone
2. RUN `docker build --tag custom-haproxy .` to build image
3. RUN `docker compose up -d` to start (you can change port before it)
4. RUN `docker ps`  to check if it is running


# HaConfig (Can use HAPROXY_CONFIG_STRING to override)

Should be something like this
```
global
  log 127.0.0.1   local0 debug
  maxconn 2046
  chroot /var/lib/haproxy
  stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
  stats timeout 30s
  user haproxy
  group haproxy
  daemon

  # Default SSL material locations
  ca-base /etc/ssl/certs
  crt-base /etc/ssl/private

  # Default ciphers to use on SSL-enabled listening sockets.
  # For more information, see ciphers(1SSL). This list is from:
  #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  # An alternative list with additional directives can be obtained from
  #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
  ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
  ssl-default-bind-options no-sslv3

defaults
  log     global
  mode    http
  option  httplog
  option  dontlognull
  timeout connect 5000
  timeout client  50000
  timeout server  50000
  #errorfile 400 /etc/haproxy/errors/400.http
  #errorfile 403 /etc/haproxy/errors/403.http
  #errorfile 408 /etc/haproxy/errors/408.http
  #errorfile 500 /etc/haproxy/errors/500.http
  #errorfile 502 /etc/haproxy/errors/502.http
  #errorfile 503 /etc/haproxy/errors/503.http
  #errorfile 504 /etc/haproxy/errors/504.http

frontend haproxynode
    bind *:80
    mode http
    default_backend backendnodes
backend backendnodes
  balance roundrobin
  option forwardfor
  http-request set-header X-Forwarded-Port %[dst_port]
  http-request add-header X-Forwarded-Proto https if { ssl_fc }
  option httpchk HEAD /main HTTP/1.0
  server node1 backend-api:8088 check
  

listen stats
  bind :32700
  stats enable
  stats uri /
  stats hide-version
```
