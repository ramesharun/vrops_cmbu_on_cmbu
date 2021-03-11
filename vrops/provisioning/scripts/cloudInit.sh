#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#set IS_SAAS environment true
mkdir -p /opt/vmware
touch /opt/vmware/deployed_on_saas.sh
chmod 755 /opt/vmware/deployed_on_saas.sh
echo "export IS_SAAS=true" >> /opt/vmware/deployed_on_saas.sh
cat /opt/vmware/deployed_on_saas.sh
# Set VAMI hostname
#/opt/vmware/share/vami/vami_set_hostname
echo "Installing Amazon SSM Agent on $(hostname)"

url="https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm"
file_path="/tmp/amazon-ssm-agent.rpm"
curl ${url} -o ${file_path}
rpm -ivh --replacepkgs ${file_path}
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
rm ${file_path}

ip_address=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')
echo "Private IP : $ip_address"

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
instance_id=$(curl  -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/instance-id)

echo "Instance ID : $instance_id"
echo "Amazon SSM Agent successfully installed $(hostname)"

echo "Sleeping for 7 minutes"
sleep 420

echo "Executing casa ping after 7 minutes"
pingjson=$(curl --insecure --silent https://localhost/casa/security/ping)
# thumbprint=$(curl --insecure --silent https://localhost/casa/slice/thumbprint)

for i in {0..20}
  do
    if [[ $pingjson == {*  ]]
        then
            echo "casa API is online now"
            curl --insecure --silent https://localhost/casa/security/ping >> /tmp/slice.txt
            echo "Getting thumbprint"
            thumbprint=$(curl --insecure --silent https://localhost/casa/slice/thumbprint)
            chmod 777 /tmp/slice.txt
            cat /tmp/slice.txt
            echo "Thumbprint : $thumbprint Private IP:  $ip_address Instance Id : $instance_id" >> /tmp/slice.txt
            echo "Instance is ready for CASA configuration"
            echo "Configuring the cluster" >> /tmp/slice.txt
            output=$(curl --insecure -X POST https://localhost/casa/public/cluster -H "Accept: application/json;charset=UTF-8" -H "Content-type: application/json;charset=UTF-8" -d "{\"admin_password\": \"Admin@123\",\"ntp_servers\" : [ \"169.254.169.123\" ], \"init\" : true, \"master\" : { \"name\" : \"$instance_id\", \"address\" : \"$ip_address\",\"thumbprint\" : \"$thumbprint\"}}")
            echo "Executed the cluster $output" >> /tmp/slice.txt
            break
    else
            echo "Waiting for casa api to come up"
            sleep 30
            pingjson=$(curl --insecure --silent https://localhost/casa/security/ping)
    fi
  done


 

