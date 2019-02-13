#!/bin/bash

function log
{
    echo "`date`:$1"
}


log "Trinket Reloader Running!"

config=$1
if [ -z "$config"]; then
  log "ERROR - no yaml config file/url specified"
  exit 1
fi

log "config file is yaml format, list of student names and shared trinket project ids"

while true; do
   log "TODO - get config file"
   curl $config > config.yaml
   log "TODO - if end token in it stop"
   log "TODO - get trinket project json for each in config"
   log "TODO - for last 3(?config) run in random order"
   log "TODO - run by generating a script which is then called"
   log "TODO - if sleep time in it, use that"

   sleep 5
   log "TODO - git pull this project to update itself - hence can change a little while running"
done
