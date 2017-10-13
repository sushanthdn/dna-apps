<!-- dx-header -->
# Apache Spark Standalone Cluster (DNAnexus Platform App)

spark_standalone is a DNA platform application which allows you to run your spark application on dna platform.
This application brings up a spark standalone cluster and runs your spark application.

This application depends on asset [spark_asset](https://github.com/sushanthdn/dna-apps/tree/master/spark_asset).

# How to build this application 
1. First you need to [build](https://github.com/sushanthdn/dna-apps/tree/master/spark_asset) spark_asset 
2. Get the record id and add it as assetDepends in dxapp.json file (replace the following id under assetDepends with resource id from your project)
```json
    "assetDepends": [
      {
        "id": "record-F7P8vf80K0g6X90G92yG4pB1"
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
```bash
sreddy@sreddy-mv-ltmp-x.local:~/dev$ dx run spark_standalone -iapplication=SparkExample/spark-examples_2.11-2.2.0.jar -iexecutors=2 -iapp_args=1 -iclass=org.apache.spark.examples.SparkPi  -y

Using input JSON:
{
    "executors": 2, 
    "app_args": "1", 
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
