app        = $(shell basename "${PWD}" | sed 's|docker-||g')
branch     = $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "unstable")
build_date = $(shell date -u +%FT%T.%S%Z)
commit     = $(shell git rev-parse --short HEAD 2> /dev/null || echo "unstable")
img        = ${ns}/${app}:${tag}
ns         = gruen
tag        = $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "unstable")

.PHONY: build
build: lint
	docker build \
    --build-arg BRANCH_NAME=${branch} \
    --build-arg BUILD_DATE=${build_date} \
    --build-arg COMMIT_SHA=${comimt} \
    -t ${img} .
	
.PHONY: clean
clean:
	docker rmi ${img}

.PHONY: lint
lint:
	# docker run -i --rm hadolint/hadolint:latest < Dockerfile
	
.PHONY: push
push:
	docker push ${img}

.PHONY: run
run:
	docker run -d \
		-v "/etc/localtime:/etc/localtime:ro" \
		-v "/tmp/.X11-unix:/tmp/.X11-unix" \
		-v "${DCONF}/signal:/home/signal/.config/Signal" \
		-e DISPLAY=unix"${DISPLAY}" \
		--name signal_make_run \
		${img}

.PHONY: test
test:
	docker run --rm \
		-v "${PWD}:/test" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--workdir /test \
		--name ${app}_container_structure_test \
		gcr.io/gcp-runtimes/container-structure-test:latest \
			test \
			--image ${img} \
			--config /test/test.yaml

ifndef VERBOSE
  .SILENT:
endif
