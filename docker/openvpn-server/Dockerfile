# Original credits:
#       https://github.com/jpetazzo/dockvpn
#       https://github.com/kylemanna/openvpn

# Smallest base image
FROM alpine:latest

LABEL maintainer="Ryan Northey <ryan@synca.io>"

RUN apk add --update gettext openvpn iptables bash  && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN /etc/openvpn

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

COPY ovpn_run /usr/local/bin/ovpn_run
COPY push-names /etc/openvpn/push-names
COPY server.conf.template /etc/openvpn/server.conf.template
COPY ovpn_env.sh.template /etc/openvpn/ovpn_env.sh.template

CMD ["/usr/local/bin/ovpn_run"]

RUN mkdir -p /var/run/openvpn/sockets \
        && chown -R openvpn:openvpn /var/run/openvpn/sockets
