WORK_DIR=`pwd`
CONTAINER_WORK_DIR="/home/ssl-coach"

CONTAINER_NAME="ssl-coach"
DOCKER_IMAGE="ssl-coach"

# Executando o docker
docker run  -it \
            --rm \
            --user=$(id -u) \
            --name=$CONTAINER_NAME \
            --volume="/dev:/dev" \
            --privileged \
            --net=host \
            --volume="${WORK_DIR}/config:${CONTAINER_WORK_DIR}/config" \
            --volume="${WORK_DIR}/logs:${CONTAINER_WORK_DIR}/bin/logs" \
            -v $HOME/.Xauthority:/root/.Xauthority \
            $DOCKER_IMAGE
