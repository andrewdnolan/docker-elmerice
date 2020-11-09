# Elmer/Ice Docker Image

To download this Elmer/Ice image, execute the command:   
```{bash}
docker pull andrewdnolan/elmerice
```  

## First Time
The first time you run the docker command:  
```{bash}
docker run -v $(pwd):/home/glacier/shared_directory -it --name=NAME andrewdnolan/elmerice  
```
where `NAME` is your docker image instance name. A sensible choice might be `elmerenv`.

A special thanks to Nick Richmond and his [docker image](https://hub.docker.com/r/nwrichmond/elmerice), which was used as the template for this repo.  

## Subsequent Times
```{bash}
docker start NAME
```
Or use the docker GUI and start the container.

For an interactive session:
```{bash}
docker exec -it NAME bash
```
Or, to just execute a command in the background:
```{bash}
docker exec NAME sh -c "ElmerSolver ..."
```
