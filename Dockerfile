FROM arm64v8/ubuntu:22.04

WORKDIR /app

ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates wget default-jre perl \
    && wget https://dlcdn.apache.org/druid/0.22.1/apache-druid-0.22.1-bin.tar.gz \
    && tar -zxvf apache-druid-0.22.1-bin.tar.gz \
    && mv apache-druid-0.22.1 druid \
    && rm -rf /var/lib/apt/lists/* 

# expose ports for controller/broker/server/admin
EXPOSE 8888

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
ENV DRUID_SKIP_JAVA_CHECK=1

WORKDIR /app/druid
RUN printf "\ndruid.generic.useDefaultValueForNull=false" >> conf/druid/single-server/micro-quickstart/_common/common.runtime.properties
ENTRYPOINT ["./bin/start-micro-quickstart"]
