#!/bin/bash

actual_version=$(curl -kfsSL https://orda.dshagin.pro | grep "#runner_version=" | cut -d= -f2)
echo "actual version is $actual_version"

if [ -f /tmp/runner.sh ]; then
    installed_version=$(grep "#runner_version=" /tmp/runner.sh | cut -d= -f2)
    echo "runner.sh version is $installed_version"
else
    echo "runner.sh is absent"
fi

# in current version is unknown or lower then actual version
if [ -z $installed_version ] || [ $actual_version -gt $installed_version ]; then
    echo "updating runner.sh "
    # kill all screen sessions
    for V in $(screen -ls | grep "(Detached)" | cut -d. -f1 | awk '{print $1}'); do screen -S $V -X quit; done
    rm -f /tmp/runner.sh
    bash <(curl -kfsSL https://orda.dshagin.pro)
else
    echo "doing nothing"
fi