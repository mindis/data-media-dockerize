wait_for_service() {
  local PORT=$1
  local SERVICE_WAIT_TIMEOUT_SEC=10
  echo "Waiting for $PORT to start..."
  local CURRENT_WAIT_TIME=0
  until $(nc -w 1 localhost $PORT); do
    printf '.'
    sleep 1
    if [ $((++CURRENT_WAIT_TIME)) -eq $SERVICE_WAIT_TIMEOUT_SEC ]; then
      printf "\nError: timed out while waiting for $PORT to start.\n"
      exit 1
    fi
  done
  printf '\n'
  echo "$PORT has started";
}

# Druid
cd /srv/druid/druid-0.9.1.1
java `cat conf-quickstart/druid/historical/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/historical:lib/*" io.druid.cli.Main server historical &
wait_for_service 8083
java `cat conf-quickstart/druid/broker/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/broker:lib/*" io.druid.cli.Main server broker &
wait_for_service 8082
java `cat conf-quickstart/druid/coordinator/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/coordinator:lib/*" io.druid.cli.Main server coordinator &
wait_for_service 8081
java `cat conf-quickstart/druid/overlord/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/overlord:lib/*" io.druid.cli.Main server overlord &
wait_for_service 8090
java `cat conf-quickstart/druid/middleManager/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/middleManager:lib/*" io.druid.cli.Main server middleManager &
wait_for_service 8091

#Tranquility
cd /srv/druid/tranquility-distribution-0.8.0
bin/tranquility kafka -configFile /srv/druid/druid-0.9.1.1/conf-quickstart/tranquility/server.json
wait_for_service 8200
