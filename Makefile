include scripts/env

# 全局通用变量
GO              := go
GORUN           := ${GO} run
GOPATH          := $(shell ${GO} env GOPATH)
GOARCH          ?= $(shell ${GO} env GOARCH)
GOBUILD         := ${GO} build
WORKDIR         := $(shell pwd)
GOHOSTOS        := $(shell ${GO} env GOHOSTOS)
SHORTNAME       ?= $(shell basename $(shell pwd))
NAMESPACE       ?= $(shell basename $(shell cd ../;pwd))

# 自动化版本号
GIT_COMMIT      := $(shell git rev-parse HEAD 2>/dev/null)
GIT_BRANCH      := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
BUILD_DATE      := $(shell date -u '+%Y-%m-%dT%H:%M:%SZ')
COMMIT_DATE     := $(shell git --no-pager log -1 --format='%ct' 2>/dev/null)
PREFIX_VERSION  := $(shell ./scripts/version.sh prefix)
RELEASE_VERSION ?= $(shell ./scripts/version.sh release)
BUILD_LD_FLAGS  := "-X 'github.com/grpc-kit/pkg/version.Appname=chatgpt.v1.francisar' \
                -X 'github.com/grpc-kit/pkg/version.CliVersion=${CLI_VERSION}' \
                -X 'github.com/grpc-kit/pkg/version.GitCommit=${GIT_COMMIT}' \
                -X 'github.com/grpc-kit/pkg/version.GitBranch=${GIT_BRANCH}' \
                -X 'github.com/grpc-kit/pkg/version.BuildDate=${BUILD_DATE}' \
                -X 'github.com/grpc-kit/pkg/version.CommitUnixTime=${COMMIT_DATE}' \
                -X 'github.com/grpc-kit/pkg/version.ReleaseVersion=${RELEASE_VERSION}'"

# 构建Docker容器变量
BUILD_GOOS      ?= $(shell ${GO} env GOOS)
IMAGE_FROM      ?= scratch
IMAGE_HOST      ?= hub.docker.com
IMAGE_NAME      ?= ${IMAGE_HOST}/${NAMESPACE}/${SHORTNAME}
IMAGE_VERSION   ?= ${RELEASE_VERSION}

# 部署与运行相关变量
BUILD_ENV       ?= local
DEPLOY_ENV      ?= dev

##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Check

.PHONY: precheck
precheck: ## Check environment.
	@echo ">> precheck environment"
	@./scripts/precheck.sh

##@ Development

.PHONY: generate
manifests: ## Generate deployment manifests files.
	@NAMESPACE=${NAMESPACE} \
		IMAGE_NAME=${IMAGE_NAME} \
		IMAGE_VERSION=${IMAGE_VERSION} \
		BUILD_ENV=${BUILD_ENV} ./scripts/manifests.sh ${DEPLOY_ENV}

generate: precheck ## Generate code from proto files.
	@echo ">> generation release version"
	@./scripts/version.sh update

	@echo ">> generation code from proto files"
	@./scripts/genproto.sh

fmt: ## Run go fmt against code.
	go fmt ./...

vet: ## Run go vet against code.
	go vet ./...

##@ Build

.PHONY: build
build: clean generate ## Build application binary.
	@mkdir build
	@mkdir build/deploy
	@GOOS=${BUILD_GOOS} ${GOBUILD} -ldflags ${BUILD_LD_FLAGS} -o build/service cmd/server/main.go

.PHONY: run
run: generate ## Run a application from your host.
	@${GORUN} -ldflags ${BUILD_LD_FLAGS} cmd/server/main.go -c config/app-dev-local.yaml

.PHONY: docker-build
docker-build: build manifests ## Build docker image with the application.
	@echo ">> docker build"
	@IMAGE_FROM=${IMAGE_FROM} \
		IMAGE_HOST=${IMAGE_HOST} \
		NAMESPACE=${NAMESPACE} \
		SHORTNAME=${SHORTNAME} \
		IMAGE_VERSION=${IMAGE_VERSION} ./scripts/docker.sh build

.PHONY: docker-push
docker-push: ## Push docker image with the application.
	@echo ">> docker push"
	@IMAGE_HOST=${IMAGE_HOST} \
		NAMESPACE=${NAMESPACE} \
		SHORTNAME=${SHORTNAME} \
		IMAGE_VERSION=${IMAGE_VERSION} ./scripts/docker.sh push

##@ Clean

.PHONY: clean
clean: ## Clean build.
	@echo ">> clean build"
	@rm -rf build/
