#!/bin/bash

COUNT=$(dunstctl count waiting)
ENABLED='<span color="#ffb52a"></span>'
DISABLED='<span color="#555"></span>'
if [ $COUNT != 0 ]; then DISABLED="<span color=\"#555\"> ($COUNT)</span>"; fi
if dunstctl is-paused | grep -q "false" ; then echo $ENABLED; else echo $DISABLED; fi
