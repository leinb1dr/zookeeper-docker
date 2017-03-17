# Why I do what I do  http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html

FROM debian:latest
RUN \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    apt-get install -y oracle-java8-installer wget maven && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

WORKDIR /opt

## Get binary files and put them in there proper /opt folder
RUN wget http://apache.claz.org/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz && \
  tar -zxf zookeeper-3.4.9.tar.gz && \
  rm -f zookeeper-3.4.9.tar.gz && \
  mkdir exhibitor && \
  mkdir exhibitor/conf

## Copy in exhibitor bin and properties
COPY pom.xml exhibitor/
COPY exhibitor.properties exhibitor/conf/
COPY aws-credentials.properties exhibitor/conf
WORKDIR exhibitor
RUN mvn clean package && rm -rf ~/.m2 && chmod +x target/exhibitor-1.5.6.jar

## Copy over the zookeeper config
WORKDIR /opt/zookeeper-3.4.9
RUN mkdir data && chmod -R +x bin && chmod -R 777 conf
COPY zoo.cfg conf/

#ENTRYPOINT ["bin/zkServer.sh"]
#CMD ["start-foreground"]

WORKDIR /opt/exhibitor

EXPOSE 2181 2888 3888 8080

#ENTRYPOINT ["ls"]
ENTRYPOINT ["java"]
CMD ["-jar","target/exhibitor-1.5.6.jar","-c","s3","--defaultconfig","conf/exhibitor.properties","--s3credentials","conf/aws-credentials.properties","--s3config","zookeeper1:zkconf"]
