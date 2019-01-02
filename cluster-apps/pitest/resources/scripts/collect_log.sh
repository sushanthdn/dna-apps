#!/usr/bin/env bash

set -e -o

. /etc/profile.d/dnanexus.environment.sh
. /cluster/dx-cluster.environment
. /home/dnanexus/environment

DX_PROJECT_CONTEXT_ID=project-FFb0Jjj0xppgyk0VBYB7BfZ8

DEST="/"
if [ "$#" -lt 1 ]; then
    echo "No project folder specified, logs will be copied to root"
else
    echo  "Creating folder $1 in project $DX_PROJECT_CONTEXT_ID"
    DEST="/$1"
    dx mkdir -p $DX_PROJECT_CONTEXT_ID:$DEST
fi


echo  "Initiating log collection"
/cluster/log_collector.sh /home/dnanexus/out/cluster_runtime_logs_tarball
echo  "Upload collected log to $DX_PROJECT_CONTEXT_ID:$DEST"
dx upload /home/dnanexus/out/cluster_runtime_logs_tarball/* --destination=$DX_PROJECT_CONTEXT_ID:$DEST
echo  "Done."
