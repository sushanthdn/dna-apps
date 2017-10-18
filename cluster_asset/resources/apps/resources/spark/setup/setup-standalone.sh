#!/usr/bin/env bash
set -e -x -o pipefail

echo "Setting Spark environment"
source /apps/resources/spark/spark.environment

sudo chown dnanexus $SPARK_LOG_DIR
sudo chown dnanexus $SPARK_WORK_DIR

echo "Starting Spark master"
$SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT

# If no of slaves not set, default it to 2
NO_OF_SLAVES=${SPARK_WORKER_INSTANCES:-2}
export SPARK_WORKER_INSTANCES=$NO_OF_SLAVES

echo "Starting Spark Slaves"
$SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL

# Checking status of the cluster (https://jaceklaskowski.gitbooks.io/mastering-apache-spark/spark-standalone-status.html)
echo "Checking Spark Cluster Status"
jps -lm | grep -i spark