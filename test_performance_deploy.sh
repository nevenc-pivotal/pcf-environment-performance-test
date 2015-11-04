#!/bin/bash
#
# test_performance_deploy.sh
#
# This is a helper script to test deploy/undeploy performance to various environments
#
# Please make sure that you log in to each environment separately, after setting proper CF_HOME environment.
#

PCF_ENVIRONMENTS="emea emea-2015 pws"

APPLICATION_NAME=spring-music
APPLICATION_PATH=spring-music.war
BUILDPACK_NAME=java_buildpack
INSTANCE_COUNT=1
MEMORY_SIZE=512M

for PCF_ENVIRONMENT in ${PCF_ENVIRONMENTS}
do

  CF_HOME=~/.cf-${PCF_ENVIRONMENT}
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  HOST_NAME=${APPLICATION_NAME}-${TIMESTAMP}

  DEPLOY_LOGFILE=/tmp/test_performance_deploy.${PCF_ENVIRONMENT}.target.${TIMESTAMP}.txt
  PUSH_LOGFILE=/tmp/test_performance_deploy.${PCF_ENVIRONMENT}.push.${TIMESTAMP}.txt
  DELETE_LOGFILE=/tmp/test_performance_deploy.${PCF_ENVIRONMENT}.delete.${TIMESTAMP}.txt

  cf target > ${DEPLOY_LOGFILE} 2>&1 
  LOGIN_STATUS=$?

  if [ ${LOGIN_STATUS} == 0 ]
  then
    echo "-------------------------------------------------"
    echo "Pushing ${APPLICATION_NAME} to ${PCF_ENVIRONMENT}"
    time -p cf push ${APPLICATION_NAME} -b ${BUILDPACK_NAME} -i ${INSTANCE_COUNT} -p ${APPLICATION_PATH} -m ${MEMORY_SIZE} -n ${HOST_NAME} > ${PUSH_LOGFILE} 2>&1
    echo "------"
    echo "Removing ${APPLICATION_NAME} from ${PCF_ENVIRONMENT}"
    time -p cf delete ${APPLICATION_NAME} -r -f > ${DELETE_LOGFILE} 2>&1
  else
    echo "You are not logged in properly. Please set the CF_HOME environment to ${CF_HOME} and login to the environment."
    echo ""
    echo "  e.g. "
    echo ""
    echo "    export CF_HOME=${CF_HOME}"
    echo "    cf api --skip-ssl-validation https://api.your.pcf.environment"
    echo "    cf login"
    echo "    Email> you@email.com"
    echo "    Password> *********"
    echo ""
  fi
done

