#!/bin/bash
set -e
JENKINS_NAME=${JENKINS_NAME:-jenkins}
JENKINS_VOLUME=${JENKINS_VOLUME:-jenkins-volume}
GERRIT_NAME=${GERRIT_NAME:-gerrit}
JENKINS_IMAGE_NAME=${JENKINS_IMAGE_NAME:-openfrontier/jenkins}
JENKINS_OPTS=${JENKINS_OPTS:---prefix=/jenkins}
TIMEZONE=${TIMEZONE:-Asia/Shanghai}

# Create Jenkins volume.
if [ -z "$(docker ps -a | grep ${JENKINS_VOLUME})" ]; then
    docker run \
    --name ${JENKINS_VOLUME} \
    --entrypoint="echo" \
    ${JENKINS_IMAGE_NAME} \
    "Create Jenkins volume."
fi

# Start Jenkins.
docker run \
--name ${JENKINS_NAME} \
--link ${GERRIT_NAME}:gerrit \
-p 50000:50000 \
--volumes-from ${JENKINS_VOLUME} \
-e JAVA_OPTS="-Duser.timezone=${TIMEZONE}" \
-d ${JENKINS_IMAGE_NAME} ${JENKINS_OPTS}
