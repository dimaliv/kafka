# Kafka (KRaft) docker image

Kafka (KRaft) docker image based on official Amazon production-ready distribution of the Open Java Development Kit (OpenJDK) docker image ([amazoncorretto](https://hub.docker.com/_/amazoncorretto)). This image optimized only for KRaft mode. Zookeeper does not supported.

## How to build

Requirements:

* Docker with docker compose (v1 or v2)

Build command:

```sh
docker compose build
``````

## How to run

Run requirements:

* Docker

Docker compose example is in "docker-compose.override.yml" file. You can run it by:

 ```bash
 docker compose up
 ```

## Run configuration

Kafka should be configured with commands. You can use next commands:

| Command  | Parameter  | Description  |
|---|---|---|
| --custom-set  | log.level  | Logging level. Can apply all available for Kafka values. "INFO" - default value. Some values: ALL,DEBUG,INFO,WARN,... |
|  --override | [parameter]=[value] | You can set all available parammeters from Kafka documentation |

Example:

```yml
version: "3.8"

services:
  kafka:
    command:
      - "--custom-set log.level=INFO"
      - "--override broker.id=1"
...
```

## License

MIT
