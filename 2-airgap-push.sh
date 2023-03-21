#!/bin/bash

if [[ ! -e $1 ]]; then
    echo "please provide path to deployment yaml to process"
    echo "./2-airgap-push.sh path/to/yaml"
    exit
fi

testdocker=$(docker ps)
 ## Did we found IP address? Use exit status of the grep command ##
if [ $? -eq 0 ]
then
  echo "docker is running"
else
  echo "docker is not running" >&2
  exit 1
fi


# source airgap-values
if [[ ! -e airgap-values ]]; then
    echo "airgap-values file not found. please create one by cloning example and filling values as needed."
    exit 1
fi
source airgap-values

#docker login registry
echo "logging in remote registry - pleas enter password"
docker login -u $REGISTRY_USER $DESTINATION_REGISTRY

if [ $? -eq 0 ]
then
  echo "logged in"
else
  echo "problem with registry login" >&2
  exit 1
fi

images=$(cat $1 | grep image | awk '{print $2}')
for image in ${images[@]}
do
    echo $image
    imagename=$(echo $image | sed 's/.*\///')
    echo "docker tag $image $DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename"
    docker tag $image $DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename
    echo "docker push $DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename"
    docker push $DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename
done

