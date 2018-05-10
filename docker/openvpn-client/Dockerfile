FROM alpine:edge

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN apk add --no-cache openvpn gettext

COPY client-up.sh /etc/openvpn/client-up.sh
COPY client.conf.template /etc/openvpn/client.conf.template
COPY vpn-entry.sh /usr/local/bin/entrypoint.sh
