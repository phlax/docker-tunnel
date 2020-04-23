FROM alpine

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN apk add --no-cache openvpn gettext

RUN apk add --no-cache tcpdump socat

COPY client-up.sh /etc/openvpn/client-up.sh
COPY client.conf.template /etc/openvpn/client.conf.template
COPY ovpn_env.sh.template /etc/openvpn/ovpn_env.sh.template
COPY vpn-entry.sh /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/run/openvpn/sockets \
	&& chown -R openvpn:openvpn /var/run/openvpn/sockets
