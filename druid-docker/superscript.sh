# Zookeeper
# /srv/druid/zookeeper-3.4.6/bin/zkServer.sh start &
# sleep 10

# Druid
cd /srv/druid/druid-0.9.1.1
java `cat conf-quickstart/druid/historical/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/historical:lib/*" io.druid.cli.Main server historical &
sleep 10
java `cat conf-quickstart/druid/broker/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/broker:lib/*" io.druid.cli.Main server broker &
sleep 10
java `cat conf-quickstart/druid/coordinator/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/coordinator:lib/*" io.druid.cli.Main server coordinator &
sleep 10
java `cat conf-quickstart/druid/overlord/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/overlord:lib/*" io.druid.cli.Main server overlord &
sleep 10
java `cat conf-quickstart/druid/middleManager/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/middleManager:lib/*" io.druid.cli.Main server middleManager &

#Tranquility
sleep 10
cd /srv/druid/tranquility-distribution-0.8.0
bin/tranquility kafka -configFile /srv/druid/druid-0.9.1.1/conf-quickstart/tranquility/server.json

# cd /srv/druid/druid-0.9.1.1
# bin/generate-example-metrics | curl -XPOST -H'Content-Type: application/json' --data-binary @- http://localhost:8200/v1/post/metrics