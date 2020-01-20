#!/bin/bash

# Generate self-signed cert...
export DEBIAN_FRONTEND=NONINTERACTIVE

src_cert=certs/root.pfx
domain=test1.test.local
redirect="127.0.0.1"
old_etc_hosts=old_etc_hosts.txt

function restore_ro_system {
  if ! adb shell su -c 'mount -o ro,remount /system'; then
    echo "! Cannot remount '/system' as 'ro'"
    exit 1
  fi

  echo "> Remounted '/system' as 'ro'"
}

if ! test -f $old_etc_hosts; then
  if ! adb shell cat /etc/hosts > $old_etc_hosts; then
    echo '! Failed to backup /etc/hosts'
    exit 1
  fi
else
  echo "> $old_etc_hosts already exists, skipping..."
fi

if ! adb shell "su 0 -c 'mount -o rw,remount /system'"; then
  echo "! Cannot remount '/system' as 'rw'"
  exit 1
fi

echo "> Remounted '/system' as 'rw'"

if test "$1" = "restore"; then

  adb push $old_etc_hosts /data/local/tmp/hosts

  if ! adb shell "su 0 -c 'mv /data/local/tmp/hosts /etc/hosts'"; then
    echo "! Failed to update /etc/hosts"
    restore_ro_system
    exit 1
  fi

  adb shell "su 0 -c 'chmod 644 /etc/hosts'"

  echo "> Restored '/etc/hosts'"

  adb reverse --remove-all
  adb reverse --list

else

  if ! adb shell "su 0 -c 'echo \"$redirect       $domain\" >> /etc/hosts'"; then
    echo "! Failed to update /etc/hosts"
    restore_ro_system
    exit 1
  fi

  adb shell "su 0 -c 'chmod 644 /etc/hosts'"

  echo "> Updates '/etc/hosts' with '$redirect       $domain'"

fi

restore_ro_system
