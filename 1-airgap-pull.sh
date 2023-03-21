#!/bin/bash
if [[ ! -e $1 ]]; then
    echo "please provide path to deployment yaml to process"
    echo "./1-airgap-pull.sh path/to/yaml"
    exit
fi

images=$(cat $1 | grep "image:" | awk '{print $2}')
for image in ${images[@]}
do
    echo $image
    docker pull $image 
done

