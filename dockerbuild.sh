xhost +local:docker

docker build . -f Dockerfile -t rc-ssl-coach --build-arg GITHUB_TOKEN=$1
