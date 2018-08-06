#!/usr/bin/env bash

# This one works for api.pmurray2.vdev
dx run metastore_test -j '{"uri":"thrift://metastore.dev-vpc.testtip.dnanexus.com:9083"}' -y

#dx run metastore_test -j '{"uri":"http://10.0.3.1:9083"}' -y
#dx run metastore_test -j '{"uri":"thrift://10.0.3.1:9083"}' -y
