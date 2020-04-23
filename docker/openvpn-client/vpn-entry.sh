#!/bin/sh

add_control_socket () {
    if [ ! -z "$OVPN_MANAGEMENT_SOCKET" ]; then
	echo "Adding management socket on: $OVPN_MANAGEMENT_SOCKET"
	echo "management $OVPN_MANAGEMENT_SOCKET" >> /etc/openvpn/openvpn.conf
    fi
}

mangle_templates () {
    envsubst '$VPN_SERVER_HOST $VPN_SERVER_PORT $VPN_CLIENT_NAME' < /etc/openvpn/client.conf.template > /etc/openvpn/$VPN_CLIENT_NAME.conf
    echo "Mangling templates: $OVPN_PORT_FORWARDS"
    envsubst '$OVPN_PORT_FORWARDS $OVPN_MANAGEMENT_SOCKET' < /etc/openvpn/ovpn_env.sh.template > /etc/openvpn/ovpn_env.sh
}


fix_key_permissions () {
    chmod og-rwx /etc/openvpn/client/*key
}


mangle_templates && source "/etc/openvpn/ovpn_env.sh"
add_control_socket
fix_key_permissions

# echo "Added vpn client $VPN_CLIENT_NAME ($VPN_SERVER_HOST:$VPN_SERVER_PORT)"
# echo "#### CONFIG"
cat /etc/openvpn/$VPN_CLIENT_NAME.conf
# echo "#### ENDCONFIG"
# route -n

exec openvpn --config /etc/openvpn/$VPN_CLIENT_NAME.conf
