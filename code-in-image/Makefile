REGISTRY=registry.ap-southeast-1.aliyuncs.com/j2gg0s
VPC_REGISTRY=registry-vpc.ap-southeast-1.aliyuncs.com/j2gg0s
ENVOY_SHA=7304f974de2724617b7492ccb4c9c58cd420353a
PROXY_TAG=release-1.16-025cd87a38a3864495e5f54a1916c04cd33ebacd

.PHONY: build-envoy
build-envoy:
	docker build \
		-f envoy-build-ubuntu.Dockerfile \
		--build-arg SHA=$(ENVOY_SHA) \
		-t envoy-build-ubuntu \
		-t $(VPC_REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA) \
		.

.PHONY: build-proxy
build-proxy:
	docker build \
		-f build-tools-proxy.Dockerfile \
		--build-arg TAG=$(PROXY_TAG) \
		-t build-tools-proxy \
		-t $(VPC_REGISTRY)/build-tools-proxy:$(PROXY_TAG) \
		.

.PHONY: push-envoy
push-envoy:
	docker push $(VPC_REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA)

.PHONY: push-proxy
push-proxy:
	docker push $(VPC_REGISTRY)/build-tools-proxy:$(PROXY_TAG)

.PHONY: pull-envoy
pull-envoy:
	docker pull $(REGISTRY)/envoy-build-ubuntu:latest
	docker image tag $(REGISTRY)/envoy-build-ubuntu:latest envoy-build-ubuntu

.PHONY: pull-proxy
pull-proxy:
	docker pull $(REGISTRY)/build-tools-proxy:latest
	docker image tag $(REGISTRY)/build-tools-proxy:latest build-tools-proxy

.PHONY: run-envoy
run-envoy:
	docker run -ti \
		--platform linux/amd64 \
		-v $(HOME)/.vim:/root/.vim \
		-v $(HOME)/images:/root/images \
		--name code-envoy \
		envoy-build-ubuntu /bin/zsh

.PHONY: run-proxy
run-proxy:
	docker run -ti \
		--platform linux/amd64 \
		-v $(HOME)/.ssh/id_rsa:/root/.ssh/id_rsa \
		--name code-proxy \
		build-tools-proxy /bin/zsh

.PHONY: start-envoy
start-envoy:
	docker start code-envoy

.PHONY: start-proxy
start-proxy:
	docker start code-proxy

.PHONY: exec-envoy
exec-envoy:
	docker exec -ti code-envoy /bin/zsh

.PHONY: exec-proxy
exec-proxy:
	docker exec -ti code-proxy /bin/zsh

.PHONY: clean-envoy
clean-envoy:
	docker stop code-envoy
	docker rm code-envoy

.PHONY: clean-proxy
clean-proxy:
	docker stop code-proxy
	docker rm code-proxy

.PHONY: commit-envoy
commit-envoy:
	docker ps -a | grep code-envoy | awk '{print $$1}' | xargs -I {} docker commit {} $(REGISTRY)/envoy-build-ubuntu
	docker push $(REGISTRY)/envoy-build-ubuntu

.PHONY: commit-proxy
commit-proxy:
	docker ps -a | grep code-proxy | awk '{print $$1}' | xargs -I {} docker commit {} $(REGISTRY)/build-tools-proxy
	docker push $(REGISTRY)/build-tools-proxy
