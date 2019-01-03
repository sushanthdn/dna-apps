#!/bin/bash



main() {

    echo "Value of no_of_samples: '$no_of_samples'"

    /cluster/hadoop/bin/hdfs dfsadmin -report
    logPropFile=/cluster/dnax/config/log/log4j-INFO.properties

    sleep 50000

    python /scripts/dx-spark-submit.py --log-level INFO --collect-log --app-config /scripts/test.json \
        --spark-args '--class org.apache.spark.examples.SparkPi /cluster/spark/examples/jars/spark-examples*.jar 10'

}
