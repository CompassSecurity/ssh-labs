#!/usr/bin/env bash

set -euo pipefail

declare -A SYSTEMS=(
    [kali]="kali"
    [linux-srv-01]="root bob"
    [linux-srv-02]="root alice"
    [linux-srv-03]="root alice trent"
    [linux-srv-04]="root carol trent"
    [linux-srv-05]="root trent dave"
    [linux-srv-06]="root dave"
    [linux-srv-07]="root frank"
)

# pick the system
mapfile -t services < <(printf '%s\n' "${!SYSTEMS[@]}" | sort)

PS3="Select system: "
select srv in "${services[@]}"
do
  [ -n "${srv:-}" ] && break
done

# pick the user (skipped if only one)
read -ra users <<< "${SYSTEMS[$srv]}"

if [ ${#users[@]} -eq 1 ]
then
  user="${users[0]}"
else
  PS3="Select user: "
  select user in "${users[@]}"
  do
    [ -n "${user:-}" ] && break
  done
fi

echo
echo "Logging into $srv as $user ..."
echo

docker compose exec "$srv" cat /etc/motd
docker compose exec "$srv" sudo -iu "$user" bash
