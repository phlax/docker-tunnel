#!/bin/bash


setup_dns_names () {
    local address name retries routes
    for name in $OPENVPN_DNS_NAMES; do
	retries=0
	until [ ! -z "$(getent hosts $name | awk '{ print $1 }')" ] || [ $retries -lt 25 ]; do
            retries=`expr $retries + 1`
            sleep .2;
	done
	address=$(getent hosts $name | awk '{ print $1 }')
	if [ -z "$address" ]; then
            echo "WARNING: cannot resolve route to $name, no routes have been added"
	    return
	fi
	echo "Added address for $name: $address"
	echo $name >> /etc/openvpn/dns-names
    done
}

add_control_socket () {
    if [ ! -z "$OVPN_MANAGEMENT_SOCKET" ]; then
	echo "Adding management socket on: $OVPN_MANAGEMENT_SOCKET"
	echo "management $OVPN_MANAGEMENT_SOCKET" >> /etc/openvpn/openvpn.conf
    fi
}

mangle_templates () {
    export OVPN_SERVER=${OVPN_SERVER:-192.168.255.0/24}
    address=$(ipcalc -n $OVPN_SERVER | cut -d"=" -f2)
    netmask=$(ipcalc -m $OVPN_SERVER | cut -d"=" -f2)
    export SERVER="$address $netmask"
    envsubst '$VPN_SERVER_NAME $SERVER' < /etc/openvpn/server.conf.template > /etc/openvpn/openvpn.conf
    for client_network in $OVPN_CLIENT_NETWORKS; do
	network=$(echo $client_network | cut -d: -f2)
	netmask=$(echo $client_network | cut -d: -f3)
	echo "route $network $netmask" >> /etc/openvpn/openvpn.conf
    done
    envsubst '$VPN_SERVER_NAME $OVPN_SERVER $OVPN_ROUTES $OVPN_MANAGEMENT_SOCKET' < /etc/openvpn/ovpn_env.sh.template > /etc/openvpn/ovpn_env.sh
    echo "#### CONFIG"
    cat /etc/openvpn/openvpn.conf
    echo "#### ENDCONFIG"
}

fix_key_permissions () {
    chmod og-rwx /etc/openvpn/server/*key
}

# echo "Configuring OpenVPN server"
mangle_templates && source "$OPENVPN/ovpn_env.sh"
setup_dns_names "${@}"
add_control_socket
fix_key_permissions
# echo "Starting OpenVPN server"
exec ovpn_run
