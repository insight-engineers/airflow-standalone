#!/bin/bash

set -o pipefail
echo "Building Airflow Docker image script: ${0}"
echo "Input arguments: $@"

# check for input arguments docker variant
if [ $# -gt 1 ]; then
    echo "Invalid number of arguments. Please provide only one argument for Docker variant."
    exit 1
fi

AIRFLOW_DOCKER_PATH=docker
AIRFLOW_DOCKER_VARIANT=${1:-"core"}
AIRFLOW_DOCKERFILE_PREFIX_PATH=${AIRFLOW_DOCKER_PATH}/${AIRFLOW_DOCKER_VARIANT}
AIRFLOW_DOCKERFILE_PATH=${AIRFLOW_DOCKERFILE_PREFIX_PATH}/Dockerfile
AIRFLOW_REQUIREMENTS_PATH=${AIRFLOW_DOCKERFILE_PREFIX_PATH}/requirements.txt

OUTPUT_DOCKER_IMAGE_REGISTRY=${2:-"insightengineers/airflow"}
OUTPUT_DOCKER_IMAGE_PATH=${OUTPUT_DOCKER_IMAGE_REGISTRY}:${AIRFLOW_DOCKER_VARIANT}


if [ ! -f ${AIRFLOW_DOCKERFILE_PATH} ]; then
    echo "Dockerfile not found: ${AIRFLOW_DOCKERFILE_PATH}"
    exit 1
fi

# check for requirements file
if [ ! -f ${AIRFLOW_REQUIREMENTS_PATH} ]; then
    echo "Requirements file not found: ${AIRFLOW_REQUIREMENTS_PATH}"
    exit 1
fi

# check docker command
if ! command -v docker &> /dev/null; then
    echo "Docker command not found. Please install Docker engine first."
    exit 1
fi

# ==============================================================================
echo "Building Airflow Docker image: ${AIRFLOW_DOCKER_VARIANT}"
docker build -t ${OUTPUT_DOCKER_IMAGE_PATH} -f ${AIRFLOW_DOCKERFILE_PATH} ${AIRFLOW_DOCKERFILE_PREFIX_PATH}
docker push ${OUTPUT_DOCKER_IMAGE_PATH}
