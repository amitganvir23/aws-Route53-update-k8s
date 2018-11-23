#!/bin/bash
set -x

## AWS region and credentails
region=${REGION}

## Route53 zone name and record name
zone_name=${ZONE_NAME}
rec_name=${RECORD_NAME}

## Ec2-tag
ec2_tag_key=${EC2_TAG_KEY}
ec2_tag_value=${EC2_TAG_VALUE}

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

## Making Inventory file
my_inventory=myhosts
cat > $my_inventory <<EOF
[localhost]
localhost ansible_connection=local ansible_python_interpreter=python
EOF

## Printing Variable values
echo "==========================="
echo -e "zone_name=$zone_name \nRegion=$region \nRecorName=$rec_name \nec2_tag_key=$ec2_tag_key \nec2_tag_value=$ec2_tag_value"
echo "==========================="

## Creating Yaml file
cat > route53.yml <<EOF
---
- hosts: localhost
  vars:
       - REGION: ${region}
       - zone_name: ${zone_name}
       - rec_name: ${rec_name}
       - ec2_tag_key: ${ec2_tag_key}
       - ec2_tag_value: ${ec2_tag_value}

  tasks:
   - name: sleep for 4 seconds and continue with play
     wait_for: timeout=4

   - name: Collecting Private IP address
     shell: "aws --region {{REGION}} ec2 describe-instances --filters \"Name=tag:{{ec2_tag_key}},Values={{ec2_tag_value}}\" \"Name=network-interface.addresses.private-ip-address,Values=*\" --query 'Reservations[*].Instances[*].{InstanceId:InstanceId,PrivateDnsName:PrivateDnsName,State:State.Name, IP:NetworkInterfaces[0].PrivateIpAddress}'|grep -w IP|awk '{print \$2}'|tr -d ','|tr -d '\"'"
     register: private_ips
     
   - set_fact: private_ip="{{private_ip|default([])+[item]}}"
     with_items: "{{ private_ips.stdout_lines }}"

   - name: Updatading route 53
     route53:
      state: present
      overwrite: true
      private_zone: true
      zone: "{{zone_name}}"
      record: "{{rec_name}}"
      type: A
      ttl: 30
      value: "{{private_ip}}"

EOF
## Playing playbook to update Route53
ansible-playbook -i $my_inventory route53.yml -vv
