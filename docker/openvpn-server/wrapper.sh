#!/bin/sh

echo "Starting OpenVPN server"
echo "" > /etc/openvpn/dns-names

echo $OPENVPN_DNS_NAMES

for NAME in $OPENVPN_DNS_NAMES; do
    RETRIES=0
    echo $NAME >> /etc/openvpn/dns-names
    echo "Added DNS forwarding name $NAME"
    until [ ! -z "$(getent hosts $NAME | awk '{ print $1 }')" ] || [ $RETRIES -lt 25 ]; do
        RETRIES=`expr $RETRIES + 1`
        sleep .2;
    done
    ADDRESS=$(getent hosts $NAME | awk '{ print $1 }')
    if [ -z "$ADDRESS" ]; then
        echo "WARNING: cannot resolve route to $NAME, no routes have been added"
    else
        NAT_IFACE=$(ip -o route get $ADDRESS | awk '{ print $3 }')
        echo "Adding nat masq for $ADDRESS via $NAT_IFACE"
        iptables -t nat -C POSTROUTING -s 192.168.254.0/24 -o $NAT_IFACE -j MASQUERADE || {
            iptables -t nat -A POSTROUTING -s 192.168.254.0/24 -o $NAT_IFACE -j MASQUERADE
        }
        iptables -t nat -C POSTROUTING -s 192.168.255.0/24 -o $NAT_IFACE -j MASQUERADE || {
            iptables -t nat -A POSTROUTING -s 192.168.255.0/24 -o $NAT_IFACE -j MASQUERADE
        }
    fi
done

envsubst '$VPN_SERVER_NAME' < /etc/openvpn/server.conf.template > /etc/openvpn/openvpn.conf
echo "Added vpn server config for: $VPN_SERVER_NAME"
cat /etc/openvpn/openvpn.conf

envsubst '$VPN_SERVER_NAME' < /etc/openvpn/ovpn_env.sh.template > /etc/openvpn/ovpn_env.sh
echo "Added vpn server env for: $VPN_SERVER_NAME"

exec ovpn_run
