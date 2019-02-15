#!/bin/bash

install_aws_cli()
{
    echo "Installing cli"
    curl -O https://bootstrap.pypa.io/get-pip.py
    python2.7 get-pip.py --user
    export PATH=~/.local/bin:$PATH
    pip --version
    pip install awscli --upgrade --user
    aws --version
}

main() {

    echo "Testing aws cli"


    export AWS_ACCESS_KEY_ID=access_key
    export AWS_SECRET_ACCESS_KEY=access_secret_key
    export HTTPS_APP_URL=someurl

    #sleep 50000
    install_aws_cli

    WORKER_PUBLIC_IP=$(cat /home/dnanexus/dnanexus-job.json | jq --raw-output .host | sed 's/ec2-//g' | awk -F "." '{print $1}' | sed 's/-/./g')
    HOSTED_ZONE_ID="my_prod_hosted_zone"

    echo $WORKER_PUBLIC_IP
    echo $HOSTED_ZONE_ID

    sed -i -e 's/@@HTTPS_APP_URL@@/'"$HTTPS_APP_URL"'/g' /config/route53.json
    sed -i -e 's/@@WORKER_PUBLIC_IP@@/'"$WORKER_PUBLIC_IP"'/g' /config/route53.json

    cat /config/route53.json

}
