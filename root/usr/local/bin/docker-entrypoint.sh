#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"

AutoUpgrade
ConfigureUser

if [ "$1" == 'samba' ]; then
  RunDropletEntrypoint
  DockLog "Fixing permissions on /var/log/samba"
  chown -R ${MYUSER}:${MYUSER} /var/log/samba
  DockLog "Starting app: ${1}"
  su-exec "${MYUSER}" smbd -FS --no-process-group
else
  DockLog "Starting app: ${@}"
  exec "$@"
fi

