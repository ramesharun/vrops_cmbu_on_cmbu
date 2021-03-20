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

curl "${url}" -o "${file_path}"
rpm -ivh --replacepkgs "${file_path}"
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
rm "${file_path}"

echo "SSM Agent installed successfully"

echo "AdminPassword       : ${admin_password}"
echo "AMI BuildType       : ${ami_buildtype}"
echo "AMI ChangeList      : ${ami_changelist}"
echo "cp_bucket_base_url  : ${cp_bucket_base_url}"
echo "csp_ref_link        : ${csp_ref_link}"
echo "sre_org_id          : ${sre_org_id}"
echo "base_url            : ${base_url}"
echo "pendo_key           : ${pendo_key}"
echo "license_key         : ${license_key}"

marketplace=$(cat <<EOF
      [
        { "bucket_name": "vrops-cloud-marketplace-dev", 
          "bucket_region": "us-west-2", 
          "visibility": "0"
        }
      ]
EOF
)
echo "marketplace         : $marketplace"

wget -O /tmp/cp_ova_manifest.json ${cp_bucket_base_url}/${ami_buildtype}/${ami_changelist}/cp_ova_manifest.json
ova_name=$(cat /tmp/cp_ova_manifest.json | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'cp_ova_name'\042/){print $(i+1)}}}' | tr -d '"')

echo "ova_name            : $ova_name"

ip_address=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')
echo "Private IP          : $ip_address"

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
instance_id=$(curl  -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/instance-id)
echo "Instance ID         : $instance_id"

echo "Amazon SSM Agent successfully installed $(hostname)"

echo "Sleeping for 7 minutes"
sleep 420

log="/tmp/cluster-config.log"
echo "Executing casa ping after initial boot .." >> "$log"
pingjson=$(curl --insecure --silent https://localhost/casa/security/ping)
echo "ping output         : $pingjson" >> "$log"


for i in {0..20}
  do
    if [[ $pingjson == {*  ]]
        then
            echo "casa API is online now" >> "$log"
            
            echo "Getting thumbprint"
            thumbprint=$(curl --insecure --silent https://localhost/casa/slice/thumbprint)
            chmod 777 "$log"
            echo "Thumbprint : $thumbprint Private IP:  $ip_address Instance Id : $instance_id" >> "$log"
            
            echo "Instance is ready for CASA configuration.Configuring the cluster" >> "$log"
            output=$(curl --insecure -X POST https://localhost/casa/public/cluster -H "Accept: application/json;charset=UTF-8" -H "Content-type: application/json;charset=UTF-8" -d "{\"admin_password\": \"${admin_password}\",\"ntp_servers\" : [ \"169.254.169.123\" ], \"init\" : true, \"master\" : { \"name\" : \"$instance_id\", \"address\" : \"$ip_address\",\"thumbprint\" : \"$thumbprint\"}}")
            echo "Executed the cluster $output" >> "$log"
            
            cluster_status=$(curl --silent --insecure -u "admin:${admin_password}" https://localhost/casa/cluster/status | python3 -c "import sys, json; print(json.load(sys.stdin)['cluster_state'])")
            echo "Cluster Staus : $cluster_status" >> "$log"

            while [[ $cluster_status != "INITIALIZED" ]]
            do
                if [[ $cluster_status != "INITIALIZATION_FAILED" ]]
                then
                  echo "Preparing vRealize Operations Manager for first use, it may take 30 minutes.." >> "$log"
                  sleep 60
                  cluster_status=$(curl --silent --insecure -u "admin:${admin_password}" https://localhost/casa/cluster/status | python3 -c "import sys, json; print(json.load(sys.stdin)['cluster_state'])")
                  echo "Cluster Staus : $cluster_status" >> "$log"
                else
                  echo "Cluster initalization failed" >> "$log"
                  echo '"cluster_state":"INITIALIZATION_FAILED"' >> "$log"
                  exit 1
                fi
            done  
           
            echo "getting the vrops Token" >> "$log"
            vrops_token=$(curl --insecure --silent -X POST  https://localhost/suite-api/api/auth/token/acquire -H "Content-Type: application/json" -H "Accept: application/json" -d "{\"username\" : \"admin\", \"password\" : \"${admin_password}\", \"others\" : [ ], \"otherAttributes\" : { }}"| python3 -c "import sys, json; print(json.load(sys.stdin)['token'])")
            echo "vROPS Token: $vrops_token" >> "$log"

            echo "Interface execution" >> "$log"
            inf_out=$(curl -ivk --retry 3 --retry-delay 10 -X PUT https://localhost/casa/saas/v1/cluster/connectivity/interface -H "Accept: application/json" -H "Content-type: application/json;charset=UTF-8" -H "X-vRealizeOps-API-use-unsupported: true" -u "admin:${admin_password}"  -d "{\"csp-service-reflink\": \"${csp_ref_link}\", \"ova_url\": \"${cp_bucket_base_url}/${ami_buildtype}/${ami_changelist}/$ova_name\", \"ntp_servers\": [], \"csp_sre_org_id\": \"${sre_org_id}\", \"base_url\": \"${base_url}\", \"pendo_key\": \"${pendo_key}\", \"headers\": {}, \"marketplace\": $marketplace}")
            echo "interface output $inf_out" >> "$log"
            
            echo "Disabling set up wizard" >> "$log"
            disable_wizard_out=$(curl -v --insecure --silent -k -X PUT https://localhost/telemetry/api/ceip -u "admin:${admin_password}" -H "Content-type:application/json" -H "X-vRealizeOps-API-use-unsupported: true" -d '{ "enabled": true }')
            echo "disable_wizard_out output $disable_wizard_out" >> "$log"

            echo "Java util Hashset execution" >> "$log"
            hash_out=$(curl -v --insecure --silent -k -X POST https://localhost/suite-api/internal/deployment/config/properties/java_util_HashSet -H "Accept: application/json" -H "Content-type: application/json" -H "X-vRealizeOps-API-use-unsupported: true" -H "Authorization: vRealizeOpsToken $vrops_token" -d '{"keyValues": [ { "key": "configurationWizardFirstConfigDone", "values": ["true"] } ] }')
            echo "hash_out output $hash_out" >> "$log"

            echo "Setting up Licence" >> "$log"
            lic_out=$(curl -v --insecure --silent -X POST https://localhost/suite-api/api/deployment/licenses -H "Accept: application/json" -H "Authorization: vRealizeOpsToken $vrops_token" -H "Content-type: application/json;charset=UTF-8" -d "{\"solutionLicenses\" : [ {\"id\" : null,\"licenseKey\" : \"${license_key}\",\"edition\" : null,\"others\" : [ ],\"otherAttributes\" : { }} ]}")
            echo "lic_out output $lic_out" >> "$log"
            echo "Configuration successfully completed.." >> "$log"
            
            break
    else
            echo "Waiting for casa api to come up" >> "$log"
            sleep 30
            pingjson=$(curl --insecure --silent https://localhost/casa/security/ping)
            echo "ping output $pingjson" >> "$log"
    fi
  done


  
         


