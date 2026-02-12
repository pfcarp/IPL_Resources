#!/usr/bin/env bash
if [[ -z $1 ]]; then
      echo "Missing ethernet interface!"
      echo "Usage: update_local_ip.sh <ifname>"
      exit 1
fi
base=${0##*/}
dir=${0%"$base"}
NEW_IP="$(ip addr show dev "$1" | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d '/' -f1)"
if ! cd "$dir"; then
      echo "Cannot move into $dir"
      exit 1
fi
dir="../machines"
file="$dir/$HOSTNAME"_local_ip
if ! mkdir -p "$dir"; then
      echo "Cannot create $dir folder"
      exit 1
fi
git pull --no-edit --commit
echo "$NEW_IP" >"$file"
git add "$file"
git commit -m "$HOSTNAME new ip"
git push --force-with-lease 
