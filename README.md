# Concourse CI

## Setup Concourse

>Note: Pre-Requirements Docker and Virtualbox

### Install Docker and Virtualbox
Download [docker](https://docker.com), and follow the installation instructions.
Download [virtualbox](https://www.virtualbox.org/), and follow the installation instructions.

### Create a docker machine

```sh
$ docker-machine create --driver=virtualbox concourse
```

#### set up environment variables

```sh
$ docker-machine env concourse
$ eval $(docker-machine env concourse) # connect shell
$ docker-machine stop concourse
$ docker-machine start concourse
```

### Docker compose for concourse

create a `docker-compose.yml`

```yml
concourse-db:
  image: postgres:9.5
  environment:
    POSTGRES_DB: concourse
    POSTGRES_USER: concourse
    POSTGRES_PASSWORD: changeme
    PGDATA: /database

concourse-web:
  image: concourse/concourse
  links: [concourse-db]
  command: web
  ports: ["8080:8080"]
  volumes: ["./keys/web:/concourse-keys"]
  environment:
    CONCOURSE_BASIC_AUTH_USERNAME: concourse
    CONCOURSE_BASIC_AUTH_PASSWORD: changeme
    CONCOURSE_EXTERNAL_URL: "${CONCOURSE_EXTERNAL_URL}"
    CONCOURSE_POSTGRES_DATA_SOURCE: |-
      postgres://concourse:changeme@concourse-db:5432/concourse?sslmode=disable

concourse-worker:
  image: concourse/concourse
  privileged: true
  links: [concourse-web]
  command: worker
  volumes: ["./keys/worker:/concourse-keys"]
  environment:
    CONCOURSE_TSA_HOST: concourse-web
```

create keys
```sh
$ mkdir -p keys/web keys/worker

$ ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
$ ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

$ ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

$ cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
$ cp ./keys/web/tsa_host_key.pub ./keys/worker
```

get ip of docker-machine and set external url to ip of dockermachine
```sh
$ docker-machine ip default
$ export CONCOURSE_EXTERNAL_URL=http://192.168.99.100:8080
```

### docker compose
```sh
docker-compose up
```

### build pipeline
target and login to concourse (docker-compose.yml)
start pipeline
```sh
$ fly -t concourse-ci login -c <your concourse URL>
$ fly set-pipeline -t concourse-ci -p test-app -c pipeline.yml --load-vars-from creds.yml
```

### migrate db for heroku
download heroku-cli
```sh
heroku run --app <your app name> rake db:migrate
```