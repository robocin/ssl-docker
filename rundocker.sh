WORK_DIR=`pwd`
CONTAINER_WORK_DIR="/home/ssl-coach"

CONTAINER_NAME="ssl-coach"
DOCKER_IMAGE="ssl-coach"

# Executando o docker
docker run  -it \
            --rm \
            --user=$(id -u) \
            --name=$CONTAINER_NAME \
            --memory=2048g \
            --oom-kill-disable \
            --volume="/dev:/dev" \
            --privileged \
            --net=host \
            --volume="${WORK_DIR}/config:${CONTAINER_WORK_DIR}/config" \
            --volume="/etc/group:/etc/group:ro" \
            --volume="/etc/passwd:/etc/passwd:ro" \
            --volume="/etc/shadow:/etc/shadow:ro" \
            --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
            $DOCKER_IMAGE