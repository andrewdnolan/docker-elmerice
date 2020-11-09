# Elmer/Ice Docker Image

To download this Elmer/Ice image, execute the command:   
```{bash}
docker pull andrewdnolan/elmerice
```  
A special thanks to Nick Richmond and his [docker image](https://hub.docker.com/r/nwrichmond/elmerice), which was used as the template for this repo.  

## First Time

After pulling the Elmer/Ice image with the command above, execute the command:  
```{bash}
docker run -v $(pwd):/home/glacier/shared_directory -it --name=NAME andrewdnolan/elmerice  
```
where `NAME` is your docker image instance name. A sensible choice might be `elmerenv`. The `-v $(pwd):/home/...` part of the command above mounts your current working directory as a shared directory with the Elmer/Ice container. Therefore, navigate to a sensible directory before you execute the command above. After the command is run, the container will start in the `$HOME` directory (`/home/glacier/`). Navigate to `/home/glacier/shared_directory/` to access the mounted volume. A mounted volume allows you to pass data back and forth from the container to the local machine.

To exit the Docker container use `exit` or `^D`.

## Subsequent Times
After pulling the Docker container, you only need to `docker run ...` the container the first time using. To use the container (with it's instance name: `NAME`) execute the command:

```{bash}
docker start NAME
```
Or use the docker GUI and start the container (by pressing the "play" button).

For an interactive session, with access to command line, run:
```{bash}
docker exec -it NAME bash
```

Or, to just execute a command in the background:
```{bash}
docker exec NAME sh -c "ElmerSolver ..."
```

### Why Not Use the Other Elmer/Ice Docker Images?   
This container was written as a deliberate addition to existing Elmer/Ice Docker containers. The main addition of this container is it preserves the `elmerice` directory that containers all of the user functions and examples. The `builddir` is also deliberately kept so you can test instilation by running the `cmake` test ([see here](http://elmerfem.org/elmerice/wiki/doku.php?id=compilation:tests))
