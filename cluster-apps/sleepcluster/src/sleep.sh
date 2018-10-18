#!/bin/bash

main() {

    /cluster/hadoop/bin/hdfs dfsadmin -report
    cat /cluster/dx-cluster.environment
    cat /home/dnanexus/environment

    sleep 50000
}
