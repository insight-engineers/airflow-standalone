#!/bin/bash

set -o pipefail
echo "Running Airflow Docker image script: ${0}"
echo "Input arguments: $@"

# check for input arguments docker variant
if [ $# -gt 1 ]; then
    echo "Invalid number of arguments. Please provide only one argument for Docker variant."
    exit 1
fi

AIRFLOW_DOCKER_VARIANT=${1:-"core"}

LOCAL_DAGS_PATH="$(pwd)/dags"
DOCKER_DAGS_PATH="/opt/airflow/dags"

DOCKER_IMAGE_REGISTRY="insightengineers/airflow"
DOCKER_IMAGE_PATH="${DOCKER_IMAGE_REGISTRY}:${AIRFLOW_DOCKER_VARIANT}"

# check docker command
if ! command -v docker &> /dev/null; then
    echo "Docker command not found. Please install Docker engine first."
    exit 1
fi

# ==============================================================================
echo "Running Airflow Docker image: ${DOCKER_IMAGE_PATH}"
docker run -d \
    -p 8080:8080 \
    -v ${LOCAL_DAGS_PATH}:${DOCKER_DAGS_PATH} \
    --name airflow-container-${AIRFLOW_DOCKER_VARIANT} \
    --restart unless-stopped \
    ${DOCKER_IMAGE_PATH}

echo "Airflow Docker container started: airflow-container-${AIRFLOW_DOCKER_VARIANT}"