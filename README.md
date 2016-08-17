# data-media-dockerize
Dockerizing kafka, samza and druid

sudo ./gradlew distTar

$KAFKA_HOME/bin/kafka-topics.sh --describe --topic itest --zookeeper zookeper:2181
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=itest --broker-list=kafka:9092

curl -L -H'Content-Type: application/json' -XPOST --data-binary @itest_query.json http://druid:8082/druid/v2/?pretty
curl -XPOST -H'Content-Type: application/json' --data-binary @itest_data.json http://localhost:8200/v1/post/itest