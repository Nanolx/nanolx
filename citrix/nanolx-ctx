#!/bin/sh
export ICAROOT=/opt/Citrix/ICAClient
sed -i \
    -e 's/Ceip=Enable/Ceip=Disable/' \
    -e 's/DisableHeartBeat=False/DisableHeartBeat=True/' \
    "${$ICAROOT}/config/module.ini"