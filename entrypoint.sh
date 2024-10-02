#!/bin/bash
cmd="$@"

mustpl -d '{"SERVER": "${SERVER:-SET_SERVER}", "PUBLIC_KEY": "${PUBLIC_KEY:-SET_PUBLIC_KEY}", "NAME": "${NAME:-ss}"}' -o /bin/show /opt/show-template
chmod +x /bin/show
echo "show script configurated"
readarray -d ',' -t Users_array < <(printf '%s' "${USERS}")
for User in "${Users_array[@]}";
do
 echo "${User}"
done

exec $cmd
