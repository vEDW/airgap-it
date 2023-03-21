# airgap-it
small set of scripts to help with the transfer of a kubernetes deployment into airgapped environment using a "transfer" station (pc/laptop/jumphost)

The scripts read the yaml and looks for ```image:``` items.
It pulls the images to the station.
connect station to airgapped environment 
push images to internal registry.
modify yaml to point to internal registry for images.

## pre-requisites
    - docker
    - an image registry with a project to transfer images to
    - a kubernetes application deployment yaml


## configuration

cp airgap-values.example airgap-values

edit airgap-values to fit your internal resources

```
export DESTINATION_REGISTRY="registry.yourdomain.io"
export DESTINATION_PROJECT="projectname"
export REGISTRY_USER="registry-username"
```

## useage

* connect station to internet
* pull images using the first script

```
./1-airgap-pull.sh path/to/yaml
```
* push images to internal registry
```
./2-airgap-push.sh path/to/yaml
```
* modify yaml to point to internal images

```
./3-airgap-convertdeployment.sh path/to/yaml
```


## notes

script has been tested on MacOs and linux (ubuntu).
registry tested : Harbor.
