# haproxy
custom haproxy for testing

# HAProxy Version
`1.8`

# Reference
you can reference from:
https://github.com/docker-library/haproxy/tree/9da24940385e6178f987737305ff499734437c90/1.8
To read the Dockerfile of the haproxy base image and its docker-entrypoint.sh

# Different from base
1. create default config
2. do these to make sure default config can work properly
  1. Create a system group and user to be used by HAProxy.
  2. make sure docker-entrypoint.sh can execute
  3. backup default default config for reference
  4. create a directory for stats socket
  5. create a directory for HAProxy to be able to `chroot`.
     This is a security measurement.
     Refer to http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#chroot.
2. allow you pass environment variable `HAPROXY_CONFIG_STRING` to override the default config, so that not need to mount just change the docker-compose or kubernetes yaml and restart the service its will work 
3. for how to use mutiple lines environment you can reference from ./docker-compose.yml

# To test locally or debug
1. git clone
2. RUN `docker build --tag custom-haproxy .` to build image
3. RUN `docker compose up -d` to start (you can change port before it)
4. RUN `docker ps`  to check if it is running
