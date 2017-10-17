#!/usr/bin/env bash
set -e -x -o pipefail

echo "Setting hadoop environment"
source /apps/resources/hadoop/hadoop.environment

ssh-keygen -t rsa -P '' -f /home/dnanexus/.ssh/id_rsa
sudo su -c "cat /home/dnanexus/.ssh/id_rsa.pub >> /home/dnanexus/.ssh/authorized_keys"

# remove host check on localhost and 0.0.0.0
sudo cp /apps/resources/hadoop/ssh/config /home/dnanexus/.ssh/

sudo chown dnanexus $HADOOP_LOG_DIR

/apps/hadoop/bin/hdfs namenode -format
/apps/hadoop/sbin/start-dfs.sh
/apps/hadoop/sbin/start-yarn.sh

jps