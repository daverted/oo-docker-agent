# OverOps Docker Image for Agent

__*Please note, this is not an official OverOps repository or Docker image*__

This image contains an [OverOps](http://www.overops.com) Agent which talks to a Remote Collector.  The Agent attaches to a single JVM running a sample application which generates errors.  More info on this image can be found on [DockerHub](https://hub.docker.com/r/timveil/oo-docker-agent/).

Although the image contains defaults for all *build* arguments (see `docker build` and `--build-arg`), to function properly, the image must be built with actual values from your environment or passed to the image using the appropriate *run* time environment variable (see `docker run` and `-e`).  This image accepts the following parameters.

## Build and Run Parameters

*Currently build arguments passed to the `Dockerfile` are removed in favor of their environment variable equivalents which should be provided when executing `docker run`.*

| build-arg | default value | environment variable | note |
| --- | --- | --- | --- |
| `COLLECTOR_HOST` | `collector` | `TAKIPI_MASTER_HOST` | host name of the Remote Collector |
| `COLLECTOR_PORT` | `6060` | `TAKIPI_MASTER_PORT` | port the Remote Collector is listening on |
| `MACHINE_NAME` | `agent-container` | `TAKIPI_MACHINE_NAME` | human readable name of the container |


## Examples

#### Building the Image

```bash
docker build \
    --no-cache \
    -t timveil/oo-docker-agent:latest \
    --build-arg COLLECTOR_HOST=overops-collector.example.com \
    --build-arg COLLECTOR_PORT=6060 .
```

#### Publishing the Image

```bash
docker push timveil/oo-docker-agent:latest
```

#### Running the Image

```bash
docker run \
    -e TAKIPI_COLLECTOR_HOST=overops-collector.example.com \
    -e TAKIPI_COLLECTOR_PORT=6060 \
    timveil/oo-docker-agent:latest
```