#!/bin/bash

if [[ ! -e $1 ]]; then
    echo "please provide path to deployment yaml to process"
    echo "./3-airgap-convertdeployment.sh path/to/yaml"
    exit
fi

source airgap-values

newfilename="converted-"$1
cp $1 $newfilename

images=$(cat $1 | grep image: | awk '{print $2}')
for image in ${images[@]}
do
    echo "processing "$image
    escapedimage=$(echo $image | sed 's=\/=\\/=g')
    imagename=$(echo $image | sed 's=.*\/==')
    case $OSTYPE in 
        "darwin"*)
            sed -i'.original' -e "s=$image=$DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename=g" $newfilename  
            rm $newfilename'.original'
            ;;
        "linux"*)
            sed -i "s=$image=$DESTINATION_REGISTRY/$DESTINATION_PROJECT/$imagename=g" $newfilename  
            ;;
    esac
done
echo
echo "${newfilename} created with modified images." 
echo
diff --unified $1 $newfilename
