function build_behave_image(){
    pushd ./workspace/behave
    sudo docker build -t 'magnetic/behave' .
    sudo docker run magnetic/behave:latest 
    popd
}

build_behave_image
