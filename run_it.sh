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

function run_tests(){
    pushd behave
    workon data-media-it
    pip install -r requirements.txt
    behave
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
#trap "copy_logs $LOGDIR && docker-compose -f docker-compose.yml down && docker rmi magnetic/samza:latest && docker rmi magnetic/druid:latest && docker rm docker_behave_1 && docker rmi magnetic/behave:latest" EXIT
trap "copy_logs $LOGDIR " EXIT

#build_samza_image
#build_druid_image
#build_behave_image

#sudo docker-compose up -d  

run_tests

sleep 10
