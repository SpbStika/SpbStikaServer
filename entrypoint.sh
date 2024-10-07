#!/bin/bash
cmd="$@"

mustpl -d '{"SERVER": "${SERVER:-SET_SERVER}", "PUBLIC_KEY": "${PUBLIC_KEY:-SET_PUBLIC_KEY}", "NAME": "${NAME:-ss}"}' -o /bin/show /opt/show-template
chmod +x /bin/show
echo "show script configurated"
readarray -d ',' -t wg_users_name < <(printf '%s' "${WG_USERS}")
readarray -d ',' -t wg_users_pruk < <(printf '%s' "${WG_PRUK}")
readarray -d ',' -t wg_users_puuk < <(printf '%s' "${WG_PUUK}")
readarray -d ',' -t wg_users_ips < <(printf '%s' "${WG_IP}")
if [ ! -f /etc/wireguard/wg0.conf ]; then
echo "[Interface]" >> /etc/wireguard/wg0.conf
echo "PrivateKey = "${WG_PRSK} >> /etc/wireguard/wg0.conf
echo "Address = "${WG_SIP} >> /etc/wireguard/wg0.conf
echo "ListenPort = "${WG_PORT} >> /etc/wireguard/wg0.conf
fi
exec $cmd
