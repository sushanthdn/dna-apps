# DNANexus Cluster Work Station Application

Cluster work station application lets you run a workstation with cluster_asset attached. This will give you access to hadoop, spark and hive installed on the machine.

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

## To start cluster_workstation app
* Build the app using dx build 
* Run the app using the command 
```bash
dx run cluster_workstation --ssh 
```
* If the work station is already running, you can ssh to it by 
```bash
dx ssh <job_id>
```
4. You can use the following to start spark standalone cluster with multiple workers in same node.
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
##### To stop the worker and master 
```bash
$SPARK_HOME/sbin/stop-slave.sh
$SPARK_HOME/sbin/start-master.sh
```
##### To start the worker and master again
```bash
echo "Starting Spark master"
$SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT

# If no of slaves not set, default it to 2
NO_OF_SLAVES=${SPARK_WORKER_INSTANCES:-2}
export SPARK_WORKER_INSTANCES=$NO_OF_SLAVES

echo "Starting Spark Slaves"
$SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL
```