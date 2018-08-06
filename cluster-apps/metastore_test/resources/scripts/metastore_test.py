import argparse
from pyspark.sql import SparkSession

def test_metastore(args):
    print 'Testing Metastore'
    spark = SparkSession.builder.enableHiveSupport().appName("MetastoreTest").getOrCreate()
    spark.sql('SHOW DATABASES').show()
    spark.stop()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Running metastore test query")
    parser.add_argument("query", help="SQL query")
    args = parser.parse_args()
    print("args", args)

    # Run SQLs
    test_metastore(args)