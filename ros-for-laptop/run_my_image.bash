#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="my-ros-melodic-full"

HOST_WS=$HOME/coding/ros-stuff/slam_ws
mkdir -p "$HOST_WS"

XAUTH=/tmp/.docker.xauth
if [ ! -f "$XAUTH" ]; then
  xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
  if [ -n "$xauth_list" ]; then
    echo "$xauth_list" | xauth -f "$XAUTH" nmerge -
  else
    touch "$XAUTH"
  fi
  chmod a+r "$XAUTH"
fi

docker run -it --rm \
  --name ros-melodic-laptop \
  --net=host \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --env="XAUTHORITY=$XAUTH" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$XAUTH:$XAUTH" \
  --volume="$HOST_WS:/root/ros_ws:rw" \
  --runtime=nvidia \
  "$IMAGE_NAME" \
  bash
