#!/usr/bin/env bash
set -e -x -o pipefail

echo "Starting Apache Spark in Standalone Mode"
export SPARK_HOME=/apps/spark
export SPARK_MASTER_IP=localhost
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_URL=spark://$SPARK_MASTER_IP:$SPARK_MASTER_PORT
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

$SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT
$SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL

$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --master $SPARK_MASTER_URL $SPARK_HOME/examples/jars/spark-examples_2.11-2.2.0.jar 10