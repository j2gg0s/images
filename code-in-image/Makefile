REGISTRY=registry.cn-shanghai.aliyuncs.com/j2gg0s
ENVOY_SHA=7304f974de2724617b7492ccb4c9c58cd420353a

.PHONY: build-envoy
build-envoy:
	docker build \
		-f envoy-build-ubuntu.Dockerfile \
		--build-arg SHA=$(ENVOY_SHA) \
		-t envoy-build-ubuntu \
		-t $(REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA) \
		--progress=plain .

.PHONY: push-envoy
push-envoy:
	docker push $(REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA)

.PHONY: pull-envoy
pull-envoy:
	docker pull $(REGISTRY)/envoy-build-ubuntu:latest
	docker image tag $(REGISTRY)/envoy-build-ubuntu:latest envoy-build-ubuntu

.PHONY: run-envoy
run-envoy:
	docker run -ti \
		--platform linux/amd64 \
		-v $(HOME)/.vim:/root/.vim \
		-v $(HOME)/other/src/github.com/j2gg0s/images:/root/images \
		--name code-envoy \
		envoy-build-ubuntu /bin/zsh

.PHONY: start-envoy
start-envoy:
	docker start code-envoy

.PHONY: exec-envoy
exec-envoy:
	docker exec -ti code-envoy /bin/zsh

.PHONY: clean-envoy
clean-envoy:
	docker stop code-envoy
	docker rm code-envoy

.PHONY: commit-envoy
commit-envoy:
	docker ps -a | grep code-envoy | awk '{print $$1}' | xargs -I {} docker commit {} $(REGISTRY)/envoy-build-ubuntu
	docker push $(REGISTRY)/envoy-build-ubuntu
