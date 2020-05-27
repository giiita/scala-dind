#
# Dockerfile: ubuntu:20.10
#   - scala          2.13.2
#   - sbt            1.3.10
#   - java           11.0.7
#   - docker         19.03.8
#   - docker compose 1.25.0
#
# https://github.com/giiita/scala-dind
#

# Pull base image
FROM ubuntu:20.10

# Env variables
ENV DEBCONF_NOWARNINGS yes
ENV JAVA_VERSION 11.0.7
ENV SCALA_VERSION 2.13.2
ENV SBT_VERSION 1.3.10

# Install Java
RUN \
  apt-get update && \
  apt-get install -y wget curl openjdk-11-jdk-headless && \
  java -version

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install SBT
RUN \
  curl -fsL https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar xfz - -C /root/ && \
  mkdir -p /root/.ivy2/local/ && \
  cp -r ~/sbt/lib/local-preloaded/* /root/.ivy2/local/

# Install Docker & DockerCompose
RUN \
  apt-get install -y docker-compose


ENV PATH /root/scala-$SCALA_VERSION/bin:/root/sbt/bin:$PATH

RUN sbt sbtVersion

# Define working directory
WORKDIR /root
