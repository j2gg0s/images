ENVOY_SHA=7304f974de2724617b7492ccb4c9c58cd420353a

.PHONY: envoy
envoy:
	docker build \
		-f envoy-build-ubuntu.Dockerfile \
		--build-arg SHA=$(ENVOY_SHA) \
		-t j2gg0s/envoy-build-ubuntu \
		--progress=plain .
