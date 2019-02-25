#!/bin/bash

function log
{
    echo "`date`:$1"
}

function run_ruby
{
    # java -jar lib/jruby-complete-9.2.6.0.jar "$@"
    ruby "$@"
}

log "Trinket Reloader Running!"

ruby -v
rc=$?
if [ $rc -ne 0 ]; then
  log "ERROR - require ruby (preferably 2.5++) to run"
fi

config=$1
if [ -z "$config" ]; then
  log "ERROR - no yaml config file/url specified"
  exit 1
fi

log "config file is yaml format, list of student names and shared trinket project ids"

while true; do
   log "Getting config file: $config"
   curl $config | tee config.yaml
   log ""
   log "curl rc:$?"
   log "CONFIG:"
   cat config.yaml
   echo
   log "TODO - if end token in it stop"
   run_ruby src/check_projects.rb config.yaml
   log "TODO - for last 3(?config) run in random order"
   log "TODO - run by generating a script which is then called"
   log "TODO - if sleep time in it, use that"

   sleep 5
   log "TODO - git pull this project to update itself - hence can change a little while running"
done
