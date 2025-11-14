#!/bin/sh -ex
# Cloud config to start Server
service consul stop
service nomad stop

# delete the vagrant junk
rm -rf /var/lib/consul/*
rm -rf /opt/nomad/*

# no periodic upgrades
cat << EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF


# don't compete with APT
while [[ $(lsof /var/lib/dpkg/lock) ]]; do echo "waiting"; sleep 1; done


# get params


NETWORK_HOST=$(wget -qO- http://169.254.169.254/latest/meta-data/local-ipv4)
INSTANCE_ID=$(wget -qO- http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(wget -qO- http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${AZ::-1}

TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=meta" --region $REGION --output=text | cut -f5)
VPC=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=vpc" --region $REGION --output=text | cut -f5)
for i in ${TAG_VALUE//,/ }
do
  IFS== read k v <<< $i
  export "NOMAD_${k^^}"=$v
done

# set hostname
echo "$NETWORK_HOST $INSTANCE_ID" > /etc/hosts
hostname $INSTANCE_ID
echo $INSTANCE_ID > /etc/hostname

# config
cat << EOF > /etc/consul/10-agent.json
{
    "datacenter": "$VPC"
    ,"bind_addr": "$NETWORK_HOST"
    ,"data_dir": "/var/lib/consul"
    ,"disable_remote_exec": true
    ,"disable_update_check": true
    ,"domain": "tb.net"
    ,"log_level": "INFO"
    ,"node_name": "$INSTANCE_ID"
    ,"enable_local_script_checks": true
    ,"start_join": ["consul.service.tb.net"]
    ,"dns_config": {
      "node_ttl": "1s",
      "service_ttl": {
        "*": "1s"
      }
    }
}
EOF

# SETUP NOMAD HCL
cat << EOF > /etc/nomad.hcl
bind_addr = "0.0.0.0"
log_level = "DEBUG"
data_dir = "/opt/nomad"
name = "$INSTANCE_ID"
datacenter = "$VPC"
client {
  enabled = true
  node_class = "${NOMAD_WORKLOAD}"
  meta {
EOF


# ADD IN OUR META TAGS
for i in ${TAG_VALUE//,/ }
do
  IFS== read k v <<< $i
  echo "    ${k^^}  = \"$v\"" >> /etc/nomad.hcl
done
echo >> "  }" >> /etc/nomad.hcl


# ADD IN OUR DOCKER VOLUME
if [ ! -z ${NOMAD_DOCKER_CONTROL} ]; then
cat << EOF >> /etc/nomad.hcl
  host_volume "docker-socket" {
      path = "/var/run/docker.sock"
      read_only = false
  }
EOF
fi


cat << EOF >> /etc/nomad.hcl
}
plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {

    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]
    allow_privileged = true

    auth {
      config     = "/etc/docker/config.json"
      helper     = "ecr-login"
    }
  }
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  datadog_address = "localhost:8125"
  disable_hostname = true
  collection_interval = "10s"
}

addresses {
  rpc  = "$NETWORK_HOST"
  serf = "$NETWORK_HOST"
}

advertise {
  # Defaults to the first private IP address.
  http = "$NETWORK_HOST"
  rpc  = "$NETWORK_HOST"
  serf = "$NETWORK_HOST"
}
EOF


service consul start
sleep 5
service nomad start
