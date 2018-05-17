#!/bin/sh

envsubst '$VPN_SERVER_HOST$VPN_SERVER_PORT$VPN_CLIENT_NAME' < /etc/openvpn/client.conf.template > /etc/openvpn/$VPN_CLIENT_NAME.conf
echo "Added vpn client $VPN_CLIENT_NAME ($VPN_SERVER_HOST:$VPN_SERVER_PORT)"

cat /etc/openvpn/$VPN_CLIENT_NAME.conf

echo "Starting openvpn..."
exec openvpn --config /etc/openvpn/$VPN_CLIENT_NAME.conf
