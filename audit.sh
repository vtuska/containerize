#!/bin/bash

REALPATH=$(readlink -f $1)
auditctl -w $REALPATH -k $REALPATH -p rwxa
auditctl -a always,exit -F arch=b64 -F dir=$REALPATH -k $REALPATH

