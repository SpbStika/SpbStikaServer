#!/bin/bash
//cmd="$@"

mustpl -d '{"SERVER": "${SERVER:-SET_SERVER}", "PUBLIC_KEY": "${PUBLIC_KEY:-SET_PUBLIC_KEY}", "NAME": "${NAME:-ss}"}' -o /bin/show /opt/show-template
chmod +x /bin/show
echo "show script configurated"
readarray -d ',' -t wg_users_name < <(printf '%s' "${WG_USERS}")
readarray -d ',' -t wg_users_pruk < <(printf '%s' "${WG_PRUK}")
readarray -d ',' -t wg_users_puuk < <(printf '%s' "${WG_PUUK}")
readarray -d ',' -t wg_users_ips < <(printf '%s' "${WG_IP}")
if [ ! -f /etc/wireguard/wg0.conf ]; then
cd /etc/wireguard/
echo "[Interface]" >> wg0.conf
echo "PrivateKey = ${WG_PRSK}" >> wg0.conf
echo "Address = ${WG_SIP}" >> wg0.conf
echo "ListenPort = ${WG_PORT}" >> wg0.conf
echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;iptables -A FORWARD -o %i -j ACCEPT" >> wg0.conf
echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE;iptables -D FORWARD -o %i -j ACCEPT" >> wg0.conf
for index in ${!wg_users_name[*]}
do
  echo " " >> wg0.conf
  echo "[PEER]" >> wg0.conf
  echo "# ${wg_users_name[$index]}" >> wg0.conf
  echo "PublicKey = ${wg_users_puuk[$index]}" >> wg0.conf
  echo "AllowedIPs = ${wg_users_ips[$index]}" >> wg0.conf
done
fi
if [ -f wg0.conf ]
then
    wg-quick up /etc/wireguard/wg0.conf
fi

//exec $cmd
