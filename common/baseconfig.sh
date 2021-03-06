DOCKER_APP_NAME=
DOCKER_APP_MOUNT_POINT=
DOCKER_BUILD_OPTIONS=
DOCKER_RUN_OPTIONS=
declare -A DOCKER_APP_PORT_INDICES

CONFIG_FILE="${DOCKER_APP_DIR}/../configuration"
if [ ! -f "${CONFIG_FILE}" ]; then
	echo "Please make a file called \"configuration\" in the root directory. Use configuration.example as a guide."
	exit 1
fi

source "${CONFIG_FILE}"
source "${DOCKER_APP_DIR}/docker-config"
source "${DOCKER_APP_DIR}/../registry"

if [ -z "${DOCKER_APP_NAME}" ]; then
	DOCKER_APP_NAME=${DOCKER_IMAGE_NAME}
fi

set +u
DOCKER_APP_PORT_INDEX=${DOCKER_APP_PORT_INDICES[$DOCKER_APP_NAME]}
set -u
if [ -z "${DOCKER_APP_PORT_INDEX}" ]; then
	if [[ ! "$DOCKER_APP_NAME" == base-* ]]; then
		echo "Please add ${DOCKER_APP_NAME} to the registry"
		exit 1
	fi
fi

if [ -z "${DOCKER_APP_MOUNT_POINT}" ]; then
	DOCKER_APP_VOLUME_PARAM=
else
	DOCKER_APP_VOLUME_PARAM="--volume ${DOCKER_APP_NAME}:${DOCKER_APP_MOUNT_POINT}"
fi

DOCKER_APP_RDP_PORT=$(expr ${DOCKER_APP_PORT_INDEX} + 3390)
DOCKER_APP_SSH_PORT=$(expr ${DOCKER_APP_PORT_INDEX} + 2000)
