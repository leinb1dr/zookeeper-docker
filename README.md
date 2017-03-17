# zookeeper-docker
It's been done many times, but not by me.

## Description
Docker container configured with Zookeeper and Exhibitor for dynamic configuration

## Helpful notes
- How to install java 8 on Debian: http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
- How to install zookeeper: https://www.tutorialspoint.com/zookeeper/zookeeper_installation.htm

## Commands
Build the docker container

    docker build -t local/zk:latest .

Run the docker container

    docker run -p 2181:2181 local/zk

### Helpful testing commands
Stop everything

    docker stop $(docker ps -a -q)
Remove all stopped containers

    docker rm $(docker ps -a -q)
Delete unused local images

    docker rmi $(docker images -q)
