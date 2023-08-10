# Kafka (KRaft) docker image

Kafka (KRaft) docker image based on official Amazon production-ready distribution of the Open Java Development Kit (OpenJDK) docker image ([amazoncorretto](https://hub.docker.com/_/amazoncorretto)). This image optimized only for KRaft mode. Zookeeper does not supported.

## How to build

Build requirements:

* Docker
* Make

Now you can build image by run:

```sh
make
```

or:

```sh
docker build ./src
``````

## How to run

You need to install:

* Docker

You can find run example in "docker-compose.override.yml" file. You can run it as it my:

```bash
make up
```

 or:

 ```bash
 docker-compose up -d
 ```

## Run configuration





## License

MIT
