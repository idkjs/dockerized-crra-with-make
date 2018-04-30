# How to dockerize your ReasonReact app for development in a container

[inspiration](https://medium.com/@thexap/how-to-dockerize-your-reactjs-app-ad618a48ad6b)

Create your Docker image to run a ReasonReact app

## Table of contents

1.  Create Dockerfile

2.  Create docker compose file

3.  Create Makefile

4.  Start the app

## 1) Create Dockerfile

Lets use a node 8 base image and create an app folder that will hold our source code.

We are going to be able to modify the source code files in our computer and it will automatically reflect the changes to the docker image, using the live reload functionality.

```yml
FROM node:8
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
```

## 2) Create docker compose file

Lest create the docker-compose.yml file.

We are using the Dockerfile that we created earlier, we are using the volume tag to reflect the files from the computer to the docker image. We are taking the current folder and using to map it with the folder created in the docker image.

Finally, we use the entrypoint so that the container doesn’t exit.

```yml
version: '2'

services:
  reason-web:
    image: reason-web
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 3000:3000
    volumes:
      - ./:/usr/src/app
entrypoint: "tail -f /dev/null"
```

## 3) Create the Makefile

Lest create a Makefile that is going to hold the commands to start, stop the image. Also, it is going to have the commands to install and start the app

```yml
IMAGE_NAME     := reason-web

install:
	@yarn install

start:
	@yarn run start

.started:
	@docker-compose build
	@docker-compose up -d
	@touch .started
	@echo "Docker containers are now running."

start-docker-image: .started

# Alias for watch
serve: watch

# Start the website on port 3000
watch: .started
	@docker-compose exec $(IMAGE_NAME) make install
	@docker-compose exec $(IMAGE_NAME) make start

stop:
	@docker-compose kill
	@docker-compose stop
	@docker-compose down --rmi local
	@docker-compose rm -f
  -@rm .started
```

## 4) Start the app

Start the docker image with

    make start-docker-image

Start the app with

    make watch

Open the browser and run the app. For example: localhost:3000

Open `src/App.js` and change something to see your browser hot reload.

Thanks to [mediumexport](https://github.com/xdamman/mediumexporter)
