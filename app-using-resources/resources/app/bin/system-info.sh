#!/usr/bin/env bash
echo "System Infomation"

#Welcome the user
echo "Welcome, $USER"
echo
echo "Today is `date`."
echo

#Currently active users.
echo "Following users are presently active:"
w | cut -d ' ' -f 1 | grep -v USER | sort -u
echo

#System information using uname command
echo "This is `uname -s` running on a `uname -m` processor."
echo

#Information of uptime
echo "Following is the uptime information:"
uptime
echo

#Showing free memory
echo "Memory Details:"
free
echo

#Disk space usage using df command
echo "Disk Space Utilization:"
df -mh
echo 