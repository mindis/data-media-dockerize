FROM java:8 

WORKDIR "/srv/druid"
RUN curl http://www.gtlib.gatech.edu/pub/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz -o zookeeper-3.4.6.tar.gz
RUN tar -xzf zookeeper-3.4.6.tar.gz
WORKDIR "/srv/druid/zookeeper-3.4.6"
RUN cp conf/zoo_sample.cfg conf/zoo.cfg

WORKDIR "/srv/druid"
RUN curl -O http://static.druid.io/artifacts/releases/druid-0.9.1.1-bin.tar.gz
RUN tar -xzf druid-0.9.1.1-bin.tar.gz
WORKDIR "/srv/druid/druid-0.9.1.1"
RUN ./bin/init
WORKDIR "/srv/druid/druid-0.9.1.1/conf-quickstart/druid/_common"
ADD common.runtime.properties common.runtime.properties

WORKDIR "/srv/druid"
RUN curl -O http://static.druid.io/tranquility/releases/tranquility-distribution-0.8.0.tgz
RUN tar -xzf tranquility-distribution-0.8.0.tgz
WORKDIR "/srv/druid/druid-0.9.1.1/conf-quickstart/tranquility"
ADD server.json server.json

WORKDIR "/srv/druid/druid-0.9.1.1"
ADD itest_query.json itest_query.json
ADD superscript.sh superscript.sh
RUN chmod 777 superscript.sh
ENTRYPOINT exec /srv/druid/druid-0.9.1.1/superscript.sh