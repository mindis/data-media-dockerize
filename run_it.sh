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
    CONTAINER_URL="$1"
    while ! curl $CONTAINER_URL
    do
      echo "$(date) - still waiting for $CONTAINER_URL"
      sleep 1
    done
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

wait_for_container zookeeper:2181
wait_for_container kafka:9092
wait_for_container druid:8082
wait_for_container druid:8081
wait_for_container druid:8083
wait_for_container druid:8091
wait_for_container druid:8090

run_tests
