#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"

AutoUpgrade
ConfigureUser

if [ "$1" == '<app>' ]; then
  RunDropletEntrypoint
  DockLog "Starting app: ${1}"
  exec su-exec "${MYUSER}" <command>
else
  DockLog "Starting app: ${@}"
  exec "$@"
fi

