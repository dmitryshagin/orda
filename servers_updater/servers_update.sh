#!/bin/bash
set -e

SERVERS=$1

function bail {
    msg=$1
    echo >&2 "FATAL ERROR > ${msg}"
    exit 1
}

function show_help {
    echo "NAME"
    echo "    servers_update.sh - check servers and update DDOSer on them"
    echo ""
    echo "SYNOPSIS"
    echo "    servers_update.sh PATH_TO_SERVERS_LIST"
    echo ""
    echo "DESRIPTION"
    echo "    Logs in to each server via ssh, check version of runner there and install/updates it if required"
    echo "    PATH_TO_SERVERS_LIST - list of servers, each string must be: IP USER PASSWORD"
    echo ""
}

echo "Hello from servers updater"

if [ -z "$SERVERS" ]; then
    show_help
    bail "Servers list is required!"
fi

if [ ! -f "$SERVERS" ]; then
    show_help
    bail "${SERVERS} >> File with servers does not exist"
fi

n=1
while read line; do
    # reading each line
    ip=$(echo $line | cut -d " " -f 1)
    user=$(echo $line | cut -d " " -f 2)
    password=$(echo $line | cut -d " " -f 3)
    echo "SERVER ${n}: ${ip}"

    # scp init.sh to server
    sshpass -p $password scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no init.sh $user@$ip:/init.sh
    # run init.sh on server
    sshpass -p $password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $user@$ip "chmod +x /init.sh && /init.sh"

    n=$((n+1))
done < $SERVERS
