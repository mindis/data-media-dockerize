function build_samza_image(){
    pushd samza-docker
    docker build -t 'magnetic/samza' .
    popd
}

function build_druid_image(){
    pushd druid-docker
    docker build -t 'magnetic/druid' .
    popd
}

function build_behave_image(){
    pushd behave
    docker build -t 'magnetic/behave' .
    #docker run magnetic/behave:latest
    popd
}


function wait_for_container(){
    CONTAINER_NAME="$1"
    local SERVICE_WAIT_TIMEOUT_SEC=10
    echo "Waiting for $CONTAINER_NAME to start..."
    local CURRENT_WAIT_TIME=0
    until [ "`sudo docker inspect -f {{.State.Running}} $CONTAINER_NAME`"=="true" ]; do
        printf '.'
        if [ $((++CURRENT_WAIT_TIME)) -eq $SERVICE_WAIT_TIMEOUT_SEC ]; then
            printf "\nError: timed out while waiting for $CONTAINER_NAME to start.\n"
            exit 1
        fi
        sleep 1;
    done;
    printf '\n'
    echo "$CONTAINER_NAME has started";
}

wait_for_port() {
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

function run_tests(){
    pushd behave
    virtualenv data-media-it
    source data-media-it/bin/activate
    pip install -r requirements.txt
    behave
    deactivate
    #docker run -itd --name docker_behave_1 magnetic/behave:latest
    popd
}

function copy_logs(){
    OUTDIR="$1"
    if [ ! -z $OUTDIR ]
    then
        # backup all containers logs 
        for CONTAINER in $(docker ps -a --format "{{.Names}}")
        do
            docker logs "$CONTAINER" &> "$OUTDIR"/"$CONTAINER".log.txt
        done
    fi
}

# remove trailing slashes so we don't write to the root dir
LOGDIR=$(echo $1 | sed 's:/*$::')

# Destroy containers when done
# trap "copy_logs $LOGDIR && docker-compose -f docker-compose.yml down && docker rmi magnetic/samza:latest && docker rmi magnetic/druid:latest && docker rm docker_behave_1 && docker rmi magnetic/behave:latest" EXIT
trap "copy_logs $LOGDIR && docker-compose -f docker-compose.yml down" EXIT
# trap "copy_logs $LOGDIR " EXIT

build_samza_image
build_druid_image
build_behave_image

sudo docker-compose up -d  

# wait_for_container docker_zookeeper_1
# wait_for_container docker_kafka_1
# wait_for_container docker_samza_1
# wait_for_container docker_druid_1

wait_for_port 2181
wait_for_port 9092
wait_for_port 8083
wait_for_port 8082
wait_for_port 8081
wait_for_port 8090
wait_for_port 8091
wait_for_port 8200

run_tests
