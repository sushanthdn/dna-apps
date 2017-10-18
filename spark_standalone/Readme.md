<!-- dx-header -->
# Apache Spark Standalone Cluster (DNAnexus Platform App)

spark_standalone is a DNA platform application which allows you to run your spark application on dna platform.
This application brings up a spark standalone cluster and runs your spark application.

This application depends on asset [cluster_asset](https://github.com/sushanthdn/dna-apps/tree/master/cluster_asset).

# How to build this application 
1. First you need to [build](https://github.com/sushanthdn/dna-apps/tree/master/cluster_asset) cluster_asset 
2. Get the record id and add it as assetDepends in dxapp.json file (replace the following id under assetDepends with record id from your project)
```json
    "assetDepends": [
      {
        "id": "record-F7Y7Jf007zzz3fb89Vx4PvV2"
      }
    ]
```
3. Build this application using dx build. Refer [link](https://wiki.dnanexus.com/Developer-Tutorials/Advanced-App-Tutorial?q=inputSpec)     
   When running the application, you need to input the following
   * Application file such as spark-examples_2.11-2.2.0.jar from platform. You need to upload your file to your project.
   * Class file that will initiate the spark program org.apache.spark.examples.SparkPi
   * Arguments passed to the main method of your main class, if any. 
   * No of executors

## Example Usage : 
spark-examples_2.11-2.2.0.jar is uploaded to SparkExample folder in the project
```bash
sreddy@sreddy-mv-ltmp-x.local:/tmp$ dx run spark_standalone -iapplication=SparkExample/spark-examples_2.11-2.2.0.jar -iworkers=2 -iapp_args=10 -iclass=org.apache.spark.examples.SparkPi  -y

Using input JSON:
{
    "workers": 2, 
    "app_args": "10", 
    "class": "org.apache.spark.examples.SparkPi", 
    "application": {
        "$dnanexus_link": {
            "project": "project-F75vXVj0gq64f9xx7zQqfKKq", 
            "id": "file-F7PxQ880gq63jxqfGBv5Gykg"
        }
    }
}
```
# Note 
* Currently the application does not take project files as argument. But it should be easy to add. 
* You can use this app as template to create more complex projects.
