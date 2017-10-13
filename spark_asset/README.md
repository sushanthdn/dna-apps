#DNANexus Spark Application Asset
This asset installs the following
* Java 8
* Spark 2.2.0

Refer this[link](https://wiki.dnanexus.com/Developer-Tutorials/Asset-Build-Process)to understand how to build asset.

#How to build spark asset ?
Execute dx build_asset command to build the spark asset.
```bash
$ dx build_asset spark_asset
```
This command will run a job which will create install java8 and spark into the lxc file system under /apps/spark
You can find the spark_asset in your project directory
```bash
sreddy@sreddy-mv-ltmp-x.local:~/dev/spark$ dx ls
spark_asset
testapp1
```
#How do I include this asset in my app?
1.  In order to include it in your app you need to first build this asset (see above) so that its part of your product. 
2.  Find the resource id of the asset. Use dx describe to get this information.
```bash
sreddy@sreddy-mv-ltmp-x.local:~/dev/spark$ dx describe spark_asset
Result 1:
ID                  record-F7P8vf80K0g6X90G92yG4pB1
Class               record
Project             project-F75vXVj0gq64f9xx7zQqfKKq
Folder              /
Name                spark_asset
State               closed
Visibility          visible
Types               AssetBundle
Properties          release=14.04, distribution=Ubuntu, version=0.0.1, description=Apache spark
                    asset and its dependencies, title=Apache Spark
Tags                -
Outgoing links      file-F7P8vBj0K0gKYZKz92Jq40jq
Created             Wed Oct 11 14:34:17 2017
Created by          sushanthkr
 via the job        job-F7P8jjj0gq6JpByv17p920qp
Last modified       Wed Oct 11 14:34:20 2017
Size                68

```
3.  In your app configuration file dxapp.json file add this asset as dependency in the runSpec. See assetDepends section in the below example. When your app is run, this asset will be included.
```json
  "runSpec": {
    "timeoutPolicy": {
      "*": {
        "hours": 48
      }
    },
    "interpreter": "bash",
    "file": "src/spark_standalone.sh",
    "systemRequirements": {
      "*": {
        "instanceType": "mem1_ssd1_x4"
      }
    },
    "assetDepends": [
      {
        "id": "record-F7P8vf80K0g6X90G92yG4pB1"
      }
    ],
    "distribution": "Ubuntu",
    "release": "14.04"
  },
```
4. If you want to run a spark standalone server, include the following in your app code.
```
echo "Starting Apache Spark in Standalone Mode"
export SPARK_HOME=/apps/spark
export SPARK_MASTER_IP=localhost
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_URL=spark://$SPARK_MASTER_IP:$SPARK_MASTER_PORT
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
export SPARK_WORKER_INSTANCES=$executors

$SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT
$SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL
```
