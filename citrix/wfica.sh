#!/bin/sh
export ICAROOT=/opt/Citrix/ICAClient
export LD_LIBRARY_PATH=/opt/Citrix/ICAClient/lib
${ICAROOT}/wfica -file "${1}"
