#!/bin/bash

if test -z $1; then
    echo "Usage:"
    echo "\t ./scripts/docker.sh build"
    echo "\t ./scripts/docker.sh push"
fi

# 生成的容器镜像地址
IMAGE_ADDR=${IMAGE_HOST}/${NAMESPACE}/${SHORTNAME}:${IMAGE_VERSION}

function build() {
  # 如未设置父镜像，默认为scratch
  if test -z ${IMAGE_FROM}; then
      IMAGE_FROM=scratch
  fi

  cp scripts/templates/Dockerfile ./

  GOHOSTOS=$(go env GOHOSTOS)

  if test ${GOHOSTOS} = "darwin"; then
      sed -i "" "s#{{IMAGE_FROM}}#${IMAGE_FROM}#g" Dockerfile
  else
      sed -i "s#{{IMAGE_FROM}}#${IMAGE_FROM}#g" Dockerfile
  fi

  docker build -t ${IMAGE_ADDR} ./
  echo "Now you can upload image: "docker push ${IMAGE_ADDR}""
}

function push() {
  docker push ${IMAGE_ADDR}
}

$1
