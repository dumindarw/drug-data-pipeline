#!/bin/bash

function exitColumnStore {
  /usr/bin/columnstore-stop
}

rm -f /var/run/syslogd.pid

trap exitColumnStore SIGTERM

exec "$@" &

wait