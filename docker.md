# Docker
Documentation notes for using Docker [https://docker.com/](https://docker.com/).

## Install
Easily on Linux:

    apt-get install docker.io

See all commands

    docker

## Brief
Docker is application that builds **containers** to host your own isolated Operating Systems.
You can create your Docker Image with any service/language and deploy them to your servers.
This saves time provisioning for every server.

I think the main benefit is that you could accidently mess up your docker container,
and your real server won't be affected. You could just repull the image.

## Create Docker Container

    $ sudo docker pull debian

or Create and Run

    $ sudo docker run debian
    $ sudo docker run ubuntu:14.04

## Run Docker Interactively
This is just like accessing a virtual machine, but's it's a docker **container**.

- The `-t` means seudo-tty inside the new container
- The `-i` means allows interactive mode via STDIN
- The `ubuntu` is the docker container name, you can see them with `$ docker images`
    - You want to connect with from the image list `repository:tag`
    - If you had `ubuntu:12.04` and `ubuntu:14.04` in the image list, you can connect just using ubuntu and it will appear as `ubuntu:latest`
- The `/bin/bash` is the shell to use.

    $ sudo docker run -t -i debian /bin/bash
    $ sudo docker run -t -i ubuntu:14.04 /bin/bash

## See what's running in Containers
When you run this notice the "Names" column auto generated for running processes.

    $ sudo docker ps

Mine created one called `romantic_franklin`, I can see anyone processes via:

    $ sudo docker logs romantic_franklin

## Stopping/Starting a container

    $ sudo docker stop romantic_franklin
    $ sudo docker start romantic_franklin

Check the Status of the container

    $ sudo docker ps

## Testing a Flask Container
This will download the dependencies, and the command `python app.py` runs it.
Make sure you find the name of the container with `$ sudo docker ps` it will be
different from below.

- The `-d` runs in detached mode (in the background)
- The `-P` lets Docker mapp to ports exposed from the image to our host.

    $ sudo docker run -d -P training/webapp python app.py
    $ sudo docker ps

Visit [http://localhost:5000](http://localhost:5000)

We can change the port with

    $ sudo docker run -d -p 5000:5000 training/webapp python app.py

To see a port provide the name (Remember `$ sudo docker ps`), this is an easier way:

    $ sudo docker port insane_mclean 5000

See the logs of the flask container

    $ sudo docker logs insane_mclean

See the processes running in a container

    $ sudo docker top insane_mclean

## Inspecting a Container

See the entire configuration in JSON format

    $ sudo docker inspect insane_mclean

We can grab the IP address with

    $ sudo docker inspect -f '{{ .NetworkSettings.IPAddress }}' insane_mclean

## Delete a Container
When deleting a container it is permanent.

    $ sudo docker stop insane_mclean
    $ sudo docker rm insane_mclean

## Search for Existing containers
This will list items from the docker public repositories

    $ sudo docker search lamp

## Update/Commit Image
We can setup this docker

    $ sudo docker pull training/sinatra

Then connect

    $ sudo docker run -t -i training/sinatra /bin/bash

Since we are going to exit after making a change (It's interactive mode, not running in the background),
make sure to copy the `root@a1f22b0f0476:/#` @`<hash>`

Inside docker make a change, such as install JSON

    $ gem install json

So we made a simple change now commit

    $ sudo docker commit -m="Added gem" -a="Jesse Boyer" a1f22b0f0476

We can also tag the image

    $ sudo docker commit -m="Added gem" -a="Jesse Boyer" a1f22b0f0476 jesse/sinatra:2

See the changes (You'll see two sinatra REPOSITORIES)

    $ sudo docker images

Use the newly commited container

    $ sudo docker run -t -i jesse/sinatra:2 /bin/bash

## Creating a container from scratch

    $ mkdir docker
    $ cd docker
    $ touch Dockerfile

Include the following in `Dockerfile`

    # This is a comment
    FROM ubuntu:14.04
    MAINTAINER Jesse Boyer <myself@mysite.com>
    RUN apt-get update && apt-get install -y ruby ruby-dev
    RUN gem install sinatra

Build the file (Make sure to check `$ sudo docker images`)

    $ sudo docker build -t="jesse/sinatra:2" .

With an image created, we can now create containers based off that

    $ sudo docker run -t -i jesse/sinatra:2 /bin/bash

You will notice that the virtual machine name is different then when you first
installed it. Mine being `3c2cb985d352` now, at first it was `a1f22b0f0476`.

Tag your image

    $ sudo docker tag 3c2cb985d352 jesse/sinatra:dev

## Using Docker Hub (The SaaS)
See [https://registry.hub.docker.com/plans/](https://registry.hub.docker.com/plans/)

Push to the docker host

    $ sudo docker push jesse/sinatra

Removing from the Hub

    $ sudo docker rmi jesse/sinatra

## Linking Containers

    I didn't get this far yet.
