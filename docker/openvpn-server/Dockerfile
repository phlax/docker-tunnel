FROM kylemanna/openvpn:edge

RUN apk add --no-cache gettext
RUN apk upgrade openvpn

COPY wrapper.sh /usr/local/bin/wrapper.sh
COPY push-names /etc/openvpn/push-names
COPY server.conf.template /etc/openvpn/server.conf.template
COPY ovpn_env.sh.template /etc/openvpn/ovpn_env.sh.template

CMD ["/usr/local/bin/wrapper.sh"]

RUN mkdir /sockets && chown -R openvpn:openvpn /sockets
