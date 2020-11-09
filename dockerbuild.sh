xhost +local:docker

docker build . -f Dockerfile -t ssl-coach --build-arg GITHUB_TOKEN=$1
