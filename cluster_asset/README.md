# DNANexus Cluster Application Asset
This asset installs the following
* Java 8
* Hadoop 2.7.4
* Spark 2.2.0
* Hive 2.3.0

Refer this [link](https://wiki.dnanexus.com/Developer-Tutorials/Asset-Build-Process) to understand how to build asset.

# How to build cluster asset ?
Execute dx build_asset command to build the cluster asset.
```bash
$ dx build_asset cluster_asset
```
This command will run a job which will create an asset with java, hadoop, spark and hive apps installed in /apps/ folder in lxc.
The command uses configuration files under /apps/resources.
You can find the cluster_asset in your project directory
```bash
sreddy@sreddy-mv-ltmp-x.local:~/dev/spark$ dx ls
cluster_asset
testapp1
```
# How do I include this asset in my app?
1.  In order to include it in your app you need to first build this asset (see above) so that its part of your product. 
2.  Find the record id of the asset. Use dx describe to get this information.
```bash
sreddy@sreddy-mv-ltmp-x.local:~/dev/spark$ dx describe spark_asset
sreddy@sreddy-mv-ltmp-x.local:/tmp$ dx describe cluster_asset
Result 1:
ID                  record-F7Qbkp00yJQ7791p93qvKjzj
Class               record
Project             project-F75vXVj0gq64f9xx7zQqfKKq
Folder              /
Name                cluster_asset
State               closed
Visibility          visible
Types               AssetBundle
Properties          release=14.04, distribution=Ubuntu, version=0.0.1, description=Apache Hadoop
                    asset and its dependencies, title=Hadoop cluster
Tags                -
Outgoing links      file-F7Qbk180yJQ6vF2393b669gY
Created             Fri Oct 13 17:40:08 2017
Created by          sushanthkr
 via the job        job-F7Qbf780gq67GYgzB2YBZyXV
Last modified       Fri Oct 13 17:40:10 2017
Size                68


```
3.  In your app configuration file dxapp.json file add this asset as dependency in the runSpec. See assetDepends section in the below example. When your app is run, this asset will be included.
```json
    "assetDepends": [
      {
        "id": "record-F7Qbkp00yJQ7791p93qvKjzj"
      }
    ]
```

## To use cluster_asset to start single hadoop node cluster 
Add the following in your application code 
```bash

# Start the namenode and resource manager
/apps/resources/hadoop/setup/setup-singlenode.sh

# Set the hadoop environment
source /apps/resources/hadoop/hadoop.environment 

# To run a sample spark application
/apps/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster /apps/spark/examples/jars/spark-examples_2.11-2.2.0.jar 10
```

## To use cluster_asset to start spark standalone cluster with multiple workers in same node.
```bash
# Starting Apache Spark in Standalone Mode
export SPARK_WORKER_INSTANCES=$workers

# Initialize spark environment
source /apps/resources/spark/spark.environment
/apps/resources/spark/setup/setup-standalone.sh

# Submit spark job
$SPARK_HOME/bin/spark-submit --class $class \
--executor-cores $cores \
--executor-memory $executor_memory \
--master $SPARK_MASTER_URL \
/home/dnanexus/application.jar $app_args
```