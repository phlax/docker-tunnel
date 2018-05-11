#!/bin/sh

echo "Starting OpenVPN server"
echo "" > /etc/openvpn/dns-names

for NAME in $OPENVPN_DNS_NAMES; do
    echo $NAME >> /etc/openvpn/dns-names
    echo "Added DNS forwarding name $NAME"
done

envsubst '$VPN_SERVER_NAME' < /etc/openvpn/server.conf.template > /etc/openvpn/openvpn.conf
echo "Added vpn server config for: $VPN_SERVER_NAME"
cat /etc/openvpn/openvpn.conf

envsubst '$VPN_SERVER_NAME' < /etc/openvpn/ovpn_env.sh.template > /etc/openvpn/ovpn_env.sh
echo "Added vpn server env for: $VPN_SERVER_NAME"

ovpn_run
