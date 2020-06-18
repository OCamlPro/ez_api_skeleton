#!/bin/bash

WD=.
CONFIG=$WD/config/api_conf.json

case "$1" in
    start)
        mkdir -p $WD/logs
        $WD/bin/api-server $CONFIG >& $WD/logs/api.log &
        echo $! > $WD/logs/api.pid
        ;;

    stop)
        PID=$(cat $WD/logs/api.pid)
        kill $PID
	;;
esac
exit 0
