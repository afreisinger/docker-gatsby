IMAGE = afreisinger/gatsby
NODE_VERSION = $(shell grep "^FROM" Dockerfile | head -n 1 | sed 's/.*://;s/-.*//')
IMAGE_LATEST = $(IMAGE):latest
IMAGE_VERSION = $(IMAGE):$(NODE_VERSION)

build:
	docker build --progress=plain --platform=linux/amd64 -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) .

# build:
# 	@echo "Starting Docker build..."
# 	@echo "Building image with tags: $(IMAGE_LATEST) and $(IMAGE_VERSION)"
# 	@if ! docker buildx inspect dev-builder >/dev/null 2>&1; then \
# 		docker buildx create --name dev-builder; \
# 		docker buildx use dev-builder; \
# 		docker buildx inspect --bootstrap; \
# 	fi
# 	docker buildx build --platform=linux/amd64 -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) .

build-no-cache:
			docker buildx build --progress=plain --no-cache --platform=linux/amd64 -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) .





push:
	docker push $(IMAGE_LATEST)
	docker push $(IMAGE_VERSION)

develop:
	docker run -it -p 8000:8000 -v ${PWD}:/site $(IMAGE)
