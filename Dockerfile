# ImmichFrame with the "show people age" patch (ungated version of upstream PR 681).
# Only the frontend is rebuilt; the .NET API comes from the official image of the same version.
#
#   podman build --build-arg VERSION=$(cat VERSION) -t immichframe-age .
ARG VERSION=v1.0.39.0

# The frontend build output is platform-independent, so build it once on the host
# architecture rather than once per target under emulation.
FROM --platform=$BUILDPLATFORM node:22-bookworm-slim AS build-node
ARG VERSION
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git clone --depth 1 --branch ${VERSION} https://github.com/immichFrame/ImmichFrame.git .
COPY show-people-age.patch /tmp/
RUN git apply /tmp/show-people-age.patch
WORKDIR /src/immichFrame.Web
RUN npm ci && npm run build

FROM ghcr.io/immichframe/immichframe:${VERSION}
# Replace rather than merge, so stale hashed chunks from the upstream build are not left behind
USER root
RUN rm -rf /app/wwwroot
COPY --from=build-node /src/immichFrame.Web/build /app/wwwroot
USER 1000
