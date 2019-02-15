#!/bin/bash
# subjob-cluster 0.0.1

pitest()
{

    /cluster/hadoop/bin/hdfs dfsadmin -report

    python /cluster/dnax/bin/dx-spark-submit.py \
        --spark-args "--class org.apache.spark.examples.SparkPi /cluster/spark/examples/jars/spark-examples*.jar 10"

}

main()
{

    dx-jobutil-new-job pitest
    echo " MAIN JOB DONE "
}
