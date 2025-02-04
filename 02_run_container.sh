#!/bin/bash
if [ ! -d "Commands" ]; then
    mkdir -p "Commands/bin"
fi

if [ ! -d "Projects/robotics40_ws/src" ]; then
    mkdir -p "Projects/robotics40_ws/src"
fi

if [ ! -d "ExampleCode" ]; then
    mkdir -p "ExampleCode"
fi

if ! command -v glxinfo &> /dev/null; then
    echo "glxinfo command not found! Execute 'sudo apt install mesa-utils' to install it."
    exit
fi

vendor=$(glxinfo | grep vendor | grep OpenGL | awk '{ print $4 }')

if [ "$vendor" == "NVIDIA" ]; then
    docker run -it --rm \
    --name ros2_foxy_desktop \
    --hostname ros2_foxy_desktop \
    --device /dev/snd \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v `pwd`/Commands/bin:/home/user/bin \
    -v `pwd`/ExampleCode:/home/user/ExampleCode \
    -v `pwd`/Projects/robotics40_ws/src:/home/user/Projects/robotics40_ws/src \
    -v ~/.ssh:/home/user/.ssh:ro \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --gpus all \
    --user $(id -u):$(id -g) \
    ros2_foxy_docker:latest \
    bash
else
    docker run --privileged -it --rm \
        --name ros2_foxy_desktop \
        --hostname ros2_foxy_desktop \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix \
        -v `pwd`/Commands/bin:/home/user/bin \
        -v `pwd`/ExampleCode:/home/user/ExampleCode \
        -v `pwd`/Projects/robotics40_ws/src:/home/user/Projects/robotics40_ws/src \
        -v ~/.ssh:/home/user/.ssh:ro \
        --device=/dev/dri:/dev/dri \
        --env="DISPLAY=$DISPLAY" \
        -e "TERM=xterm-256color" \
        --cap-add SYS_ADMIN --device /dev/fuse \
        ros2_foxy_docker:latest \
        bash
fi
