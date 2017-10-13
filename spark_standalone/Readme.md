<!-- dx-header -->
# Apache Spark Standalone Cluster (DNAnexus Platform App)

Application that will spawn apache spark cluster and allow you to run spark application

This is the source code for an app that runs on the DNAnexus Platform.
For more information about how to run or modify it, see
https://wiki.dnanexus.com/.
<!-- /dx-header -->

This app depends on asset spark_asset which installs spark in /apps/spark folder
When running the application, you need to input the following
* Application file such as spark-examples_2.11-2.2.0.jar from platform
* Class file that will initiate the spark program org.apache.spark.examples.SparkPi
* Arguments passed to the main method of your main class, if any. 
* No of executors

The app downloads the application jar file and executes spark submit 


