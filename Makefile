IMAGE = afreisinger/gatsby
PLATFORMS = linux/amd64,linux/arm64
NODE_VERSION = $(shell grep "^FROM" Dockerfile | head -n 1 | sed 's/.*://;s/-.*//')
IMAGE_LATEST = $(IMAGE):latest
IMAGE_VERSION = $(IMAGE):$(NODE_VERSION)

.PHONY: all
all: build

.PHONY: build
build:
	@echo "Starting Docker build..."
	@echo "Building Docker image for platforms: $(PLATFORMS) with tags: $(IMAGE_LATEST) and $(IMAGE_VERSION)"
	@if ! docker buildx inspect dev-builder >/dev/null 2>&1; then \
		docker buildx create --name dev-builder; \
		docker buildx use dev-builder; \
		docker buildx inspect --bootstrap; \
	fi
    # docker buildx build --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --progress=plain --output=type=local,dest=./output .
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --progress=plain --push .

.PHONY: build-no-cache
build-no-cache:
	@echo "Starting Docker build..."
	@echo "Building Docker image for platforms: $(PLATFORMS) with tags: $(IMAGE_LATEST) and $(IMAGE_VERSION)"
	@if ! docker buildx inspect dev-builder >/dev/null 2>&1; then \
		docker buildx create --name dev-builder; \
		docker buildx use dev-builder; \
		docker buildx inspect --bootstrap; \
	fi
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --progress=plain --no-cache --push .

.PHONY: push
push:
	@echo "Pushing Docker image $(IMAGE_LATEST) and $(IMAGE_VERSION) to registry..."
	docker push $(IMAGE_LATEST)
	docker push $(IMAGE_VERSION)

.PHONY: clean
clean:
	@echo "Removing buildx builder"
	docker buildx rm dev-builder

.PHONY: rebuild
rebuild: clean build
