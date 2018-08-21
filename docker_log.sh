#!/bin/bash

#####################################
# Script to get the logs of the containers on the machines
#
#####################################

read -p "Please provide the server where need to get the container logs = " tar_server
read -p "Please provide User name to login to server = " user

echo "Server to logged in = $tar_server"
echo "User to logged in = $user"

echo "Logging to server, kindly wait....."

ssh $user@$tar_server << EOF

sudo docker ps

#cont=\$(sudo docker ps | grep -v CONTAINER | awk '{print $1}')
#for container in \$cont;
for container in \$(docker ps | grep -v CONTAINER | awk '{print \$1}')
do
        echo "----------------------------------------"
        echo "Forwarding the logs in specific location"
        echo "----------------------------------------"
        echo "Forwarding logs for \${container}"
        echo "----------------------------------------"

        if [ -f /tmp/\${container}_logs.log ]; then
                echo "---------------------------------------------------------------------------"
                echo "/tmp/\${container}_logs.log is present...removing it and forwarding the logs"
                echo "---------------------------------------------------------------------------"
                rm -rf /tmp/\${container}_logs.log
                docker logs \${container} > /tmp/\${container}_logs.log
        else
                echo "---------------------------------------------------------------------------"
                echo "/tmp/\${container}_logs.log file not present.....creating and forwarding the logs"
                echo "---------------------------------------------------------------------------"
                docker logs \${container} > /tmp/\${container}_logs.log
        fi
done
echo ""
echo "----------------------------------------"
echo "Done Forwarding of logs"
echo "----------------------------------------"
echo ""

EOF





