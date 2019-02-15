#!/bin/bash
# long_spark_app 0.0.1


main() {

    python /cluster/dnax/bin/dx-spark-submit.py \
        --app-config /config/app.json \
        --spark-args "/scripts/test.py 10"

}
