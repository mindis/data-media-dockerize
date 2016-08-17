FROM java:8 
MAINTAINER Magnetic Engineering <engineering@magnetic.com>

# Install netcat; used for checking if kafka has already started
#RUN apt-get update && apt-get install -y netcat #

ADD build/distributions/* /srv/samzastuff/

WORKDIR "/srv/samzastuff"

CMD bin/run-job.sh --config-factory=org.apache.samza.config.factories.PropertiesConfigFactory --config-path=file://$PWD/config/itest.properties

