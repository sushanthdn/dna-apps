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
   * Executor memory
   * Executor cores
   * No of workers
   * Set of input files which will be copied to /home/dnanexus/in/in_files/<index>/<filename> in lxc
   * If you want to copy the output files to your project, then you need to make sure the files are present in /home/dnanexus/out/out_files folder lxc

## Example Usage : 
1. Running SparkPi example spark application
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
2. Running csv2Parquet example spark application. Copy examples/csv2Parquet to you project under SparkExample folder. 
Note that the app_args specifies the following 
* Sample patients csv file. The in_files are uploaded by app into /in/in_files/ folder. 
* Output file should be generated under out/output_files/ folder. At the end of the application run, all files under /out/output_files will be copied to your project.
```bash
sreddy@sreddy-mv-ltmp-x.local:~/IdeaProjects/dna-apps/spark_standalone/examples$ dx run spark_standalone  -iclass="com.dnanexus.spark.PhenoCsvToParquet" -iapplication="SparkExample/csv2parquet/csv2parquet-0.1.jar" -iworkers="3" -iin_files="SparkExample/csv2parquet/samples-patients.csv" -iapp_args="in/in_files/0/samples-patients.csv Patients out/output_files/patients.parquet"  -y

Using input JSON:
{
    "class": "com.dnanexus.spark.PhenoCsvToParquet", 
    "workers": 3, 
    "app_args": "in/in_files/0/samples-patients.csv Patients out/output_files/patients.parquet", 
    "application": {
        "$dnanexus_link": {
            "project": "project-F75vXVj0gq64f9xx7zQqfKKq", 
            "id": "file-F7Yv0p80gq67jxq60by8K416"
        }
    }, 
    "in_files": [
        {
            "$dnanexus_link": {
                "project": "project-F75vXVj0gq64f9xx7zQqfKKq", 
                "id": "file-F7Yj78j0gq662Bv142J5X2q4"
            }
        }
    ]
}
```
Running the above command should generate patients.parquet folder in your project.
# Note 
* You can use this app as template to create more complex projects.
