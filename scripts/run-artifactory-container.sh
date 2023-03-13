#!/usr/bin/env bash
## Heavily borrowed from: https://github.com/jfrog/terraform-provider-artifactory/tree/master/scripts

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
source "${SCRIPT_DIR}/wait-for-rt.sh"

ARTIFACTORY_REPO="${ARTIFACTORY_REPO:-releases-docker.jfrog.io/jfrog}"
ARTIFACTORY_IMAGE="${ARTIFACTORY_IMAGE:-artifactory-jcr}"
ARTIFACTORY_VERSION=${ARTIFACTORY_VERSION:-7.55.2}
echo "ARTIFACTORY_IMAGE=${ARTIFACTORY_IMAGE}" > /dev/stderr
echo "ARTIFACTORY_VERSION=${ARTIFACTORY_VERSION}" > /dev/stderr

if [ -f "${SCRIPT_DIR}/artifactory.lic" ]; then
  ARTIFACTORY_LICENSE="-v \"${SCRIPT_DIR}/artifactory.lic:/artifactory_extra_conf/artifactory.lic:ro\""
else
  ARTIFACTORY_LICENSE=""
fi

set -euf

CONTAINER_ID=$(docker run -i -t -d --rm ${ARTIFACTORY_LICENSE} -p8081:8081 -p8082:8082 -p8080:8080 \
  "${ARTIFACTORY_REPO}/${ARTIFACTORY_IMAGE}:${ARTIFACTORY_VERSION}")

export ARTIFACTORY_URL=http://localhost:8081
export ARTIFACTORY_UI_URL=http://localhost:8082

# Wait for Artifactory to start
waitForArtifactory "${ARTIFACTORY_URL}" "${ARTIFACTORY_UI_URL}"

# With this trick you can do $(./run-artifactory-container.sh) and it will directly be setup for you without the terminal output
echo "export ARTIFACTORY_CONTAINER_ID=${CONTAINER_ID}"
echo "export ARTIFACTORY_URL=\"${ARTIFACTORY_UI_URL}\""