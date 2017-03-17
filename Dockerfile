# Why I do what I do  http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html

FROM debian:latest
RUN \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    apt-get install -y oracle-java8-installer wget && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

WORKDIR /opt
RUN wget http://apache.claz.org/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz && \
  tar -zxf zookeeper-3.4.9.tar.gz && \
  rm -f zookeeper-3.4.9.tar.gz

WORKDIR zookeeper-3.4.9
RUN mkdir data
COPY zoo.cfg conf/

EXPOSE 2181 2888 3888

ENTRYPOINT ["bin/zkServer.sh"]
CMD ["start-foreground"]
