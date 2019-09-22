#!/bin/sh

echo "********************************************************"
echo "Waiting for the configuration server to start on port $CONFIGSERVER_PORT"
echo "********************************************************"
while ! `nc -z configserver $CONFIGSERVER_PORT`; do sleep 3; done
echo "*******  Configuration Server has started"

echo "********************************************************"
echo "Waiting for the eureka server to start on port $EUREKASERVER_PORT"
echo "********************************************************"
while ! `nc -z eurekaserver  $EUREKASERVER_PORT`; do sleep 3; done
echo "******* Eureka Server has started"

#echo "********************************************************"
#echo "Waiting for the ZIPKIN server to start  on port $ZIPKIN_PORT"
#echo "********************************************************"
#while ! `nc -z zipkin $ZIPKIN_PORT`; do sleep 10; done
#echo "******* ZIPKIN has started"

echo "********************************************************"
echo "Starting Zuul Service on port $ZUULSERVER_PORT"
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom                    \
     -Dspring.cloud.config.uri=$CONFIGSERVER_HOST:$CONFIGSERVER_PORT \
      -Dspring.cloud.config.password=$CONFIGSERVER_PASSWORD     \
     -Dspring.profiles.active=$PROFILE                          \
     -jar /usr/local/zuulsvr/app.jar
#     -Dspring.zipkin.baseUrl=$ZIPKIN_URI                       \
