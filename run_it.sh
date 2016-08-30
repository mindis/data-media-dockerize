function build_behave_image(){
    pushd behave
    sudo docker build -t 'magnetic/behave' .
    sudo docker run magnetic/behave:latest 
    popd
}

build_behave_image
