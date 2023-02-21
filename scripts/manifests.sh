#!/bin/bash

if test -z $1; then
    echo "Usage:"
    echo "\t ./scripts/manifests.sh dev"
fi

GOHOSTOS=$(go env GOHOSTOS)
DEPLOY_ENV=$1

# 生成的容器镜像地址
IMAGE_ADDR=${IMAGE_HOST}/${NAMESPACE}/${SHORTNAME}:${IMAGE_VERSION}

function clean() {
    rm -rf deploy/kubernetes/${DEPLOY_ENV}
}

function kubernetes() {
    mkdir -p deploy/kubernetes/${DEPLOY_ENV}/
    mkdir -p deploy/kubernetes/${DEPLOY_ENV}/config/configmap/
    cp -rf scripts/templates/kubernetes/* deploy/kubernetes/${DEPLOY_ENV}/

    if test -f config/app-${DEPLOY_ENV}-${BUILD_ENV}.yaml; then
        cp -a config/app-${DEPLOY_ENV}-${BUILD_ENV}.yaml deploy/kubernetes/${DEPLOY_ENV}/config/configmap/app.yaml
    fi

    if test ${GOHOSTOS} = "darwin"; then
        sed -i "" "s#DEPLOY_ENV#${DEPLOY_ENV}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "" "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "" "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/workloads/deployment.yaml
        sed -i "" "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/service/ingresses.yaml
        sed -i "" "s#DEPLOY_ENV#${DEPLOY_ENV}#g" deploy/kubernetes/${DEPLOY_ENV}/service/ingresses.yaml
        sed -i "" "s#IMAGE_NAME#${IMAGE_NAME}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "" "s#IMAGE_NAME#${IMAGE_NAME}#g" deploy/kubernetes/${DEPLOY_ENV}/workloads/deployment.yaml
        sed -i "" "s#IMAGE_VERSION#${IMAGE_VERSION}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
    else
        sed -i "s#DEPLOY_ENV#${DEPLOY_ENV}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/workloads/deployment.yaml
        sed -i "s#NAMESPACE#${NAMESPACE}#g" deploy/kubernetes/${DEPLOY_ENV}/service/ingresses.yaml
        sed -i "s#DEPLOY_ENV#${DEPLOY_ENV}#g" deploy/kubernetes/${DEPLOY_ENV}/service/ingresses.yaml
        sed -i "s#IMAGE_NAME#${IMAGE_NAME}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
        sed -i "s#IMAGE_NAME#${IMAGE_NAME}#g" deploy/kubernetes/${DEPLOY_ENV}/workloads/deployment.yaml
        sed -i "s#IMAGE_VERSION#${IMAGE_VERSION}#g" deploy/kubernetes/${DEPLOY_ENV}/kustomization.yaml
    fi
}

clean
kubernetes
