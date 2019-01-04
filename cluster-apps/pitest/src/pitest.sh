#!/bin/bash



main() {

    echo "Value of no_of_samples: '$no_of_samples'"

    /cluster/hadoop/bin/hdfs dfsadmin -report

    #sleep 50000

    python /cluster/dnax/bin/dx-spark-submit.py \
        --log-level INFO \
        --collect-log \
        --log-collect-dir pitestlogs \
        --app-config /scripts/app.json \
        --user-config /scripts/user.json \
        --spark-args "--class org.apache.spark.examples.SparkPi /cluster/spark/examples/jars/spark-examples*.jar $no_of_samples"

}
