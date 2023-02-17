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
push-envy:
	docker push $(REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA)

.PHONY: pull-envoy
pull-envy:
	docker pull $(REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA)
	docker image tag $(REGISTRY)/envoy-build-ubuntu:$(ENVOY_SHA) envoy-build-ubuntu
