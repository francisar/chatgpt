#!/bin/bash

source scripts/env

if test -z $1; then
    echo "Usage:"
    echo "\t ./scripts/version.sh prefix"
    echo "\t ./scripts/version.sh release"
    echo "\t ./scripts/version.sh update"
    exit 0;
fi

function prefix() {
    TEMP=$(grep "version: \".*\"" api/francisar/chatgpt/${API_VERSION}/microservice.proto)
    PREFIX_VERSION=$(echo -n $TEMP | awk -F"\"" '{ print $2 }')
    echo $PREFIX_VERSION
}

function release() {
    TEMP=$(cat VERSION)
    RELEASE_VERSION=$TEMP

    if test -z $RELEASE_VERSION; then
        RELEASE_VERSION=$(git describe --tags --dirty --always 2>/dev/null)
    fi

    echo $RELEASE_VERSION
}

function update() {
    GOHOSTS=$(go env GOHOSTOS)

    PREFIX_VERSION=$(prefix)
    RELEASE_VERSION=$(release)

    if test ${GOHOSTS} = "darwin"; then
        sed -i "" "s#version: \"${PREFIX_VERSION}\"#version: \"${RELEASE_VERSION}\"#g" api/francisar/chatgpt/${API_VERSION}/microservice.proto
    else
        sed -i "s#version: \"${PREFIX_VERSION}\"#version: \"${RELEASE_VERSION}\"#g" api/francisar/chatgpt/${API_VERSION}/microservice.proto
    fi
}

$1
