#!/usr/bin/env bash
set -e -x -o pipefail

echo "Setting hadoop environment"
source /apps/resources/hadoop/hadoop.environment

ssh-keygen -t rsa -P '' -f /home/dnanexus/.ssh/id_rsa
sudo su -c "cat /home/dnanexus/.ssh/id_rsa.pub >> /home/dnanexus/.ssh/authorized_keys"

# remove host check on localhost and 0.0.0.0
sudo cp /apps/resources/hadoop/ssh/config /home/dnanexus/.ssh/

sudo chown dnanexus $HADOOP_LOG_DIR

$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

jps