# OverOps Docker Image for Agent

__*Please note, this is not an official OverOps repository or Docker image*__

This image serves as example Agent installation which talks to a Remote Collector  The Agent attaches to sample application which generates errors.  More info can be found on [DockerHub](https://hub.docker.com/r/timveil/oo-docker-agent/).

To build the image run the following command. `SECRET_KEY` and `COLLECTOR_HOST` are a required build arguments.  `COLLECTOR_PORT` is optional and defaults to `6060`.  `MACHINE_NAME` is optional and defaults to `agent`.
```
docker build --no-cache -t timveil/oo-docker-agent:latest --build-arg SECRET_KEY=<YOUR SECRET KEY> --build-arg COLLECTOR_HOST=<YOUR COLLECTOR HOST> .
```
```
docker build --no-cache -t timveil/oo-docker-agent:latest --build-arg SECRET_KEY=<YOUR SECRET KEY> --build-arg COLLECTOR_HOST=<YOUR COLLECTOR HOST> --build-arg COLLECTOR_PORT=<YOUR COLLECTOR PORT> --build-arg MACHINE_NAME=<YOUR MACHINE NAME> .
```

To publish the image run the following command:
```
docker push timveil/oo-docker-agent:latest
```

To run the image execute the following command:
```
docker run -e TAKIPI_SECRET_KEY=<YOUR SECRET KEY> -e TAKIPI_MASTER_HOST=<YOUR COLLECTOR HOST> timveil/oo-docker-agent
```