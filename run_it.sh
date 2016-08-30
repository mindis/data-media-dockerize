function build_samza_image(){
    pushd samza-docker
    sudo docker build -t 'magnetic/samza' .
    popd
}

function build_druid_image(){
    pushd druid-docker
    sudo docker build -t 'magnetic/druid' .
    popd
}

function build_behave_image(){
    pushd behave
    sudo docker build -t 'magnetic/behave' .
    #sudo docker run magnetic/behave:latest
    popd
}

function copy_logs(){
    OUTDIR="$1"
    if [ ! -z $OUTDIR ]
    then
        # backup all containers logs 
        for CONTAINER in $(docker ps -a --format "{{.Names}}")
        do
            docker logs "$CONTAINER" &> "$OUTDIR"/"$CONTAINER".log
        done
    fi
}

# remove trailing slashes so we don't write to the root dir
LOGDIR=$(echo $1 | sed 's:/*$::')

# Destroy containers when done
trap "copy_logs $LOGDIR && docker-compose -f docker-compose.yml down && docker rmi magnetic/samza:latest && docker rmi magnetic/druid:latest && docker rmi magnetic/behave:latest" EXIT

build_samza_image
build_druid_image
build_behave_image

sudo docker-compose up -d  
