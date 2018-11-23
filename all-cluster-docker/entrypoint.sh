#!/bin/bash

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

#wget -N https://raw.githubusercontent.com/amitganvir23/amazon-cloud-formation-couchbase/master/scripts/route53_name_list

## cloinging repolist
route53_repo=${ROUTE53_REPO}
route53_file=${ROUTE53_FILE}

git clone $route53_repo

#cp -v $(echo $route53_repo|tr '/' '\n'|grep .git|cut -d '.' -f 1)/$route53_file .
find . -name ${route53_file} -exec cp {} -v . \;
sed '/^$/d' ${route53_file} |grep -v "#" > list

n=$(cat list|wc -l)
for (( i=1; i<=$n; i++ ))
do
sed -n "${i}p" list > ${i}.txt
declare $(awk '{tmp=$1} END {print "REGION=" tmp}' ${i}.txt)
declare $(awk '{tmp=$2} END {print "ZONE_NAME=" tmp}' ${i}.txt)
declare $(awk '{tmp=$3} END {print "RECORD_NAME=" tmp}' ${i}.txt)
declare $(awk '{tmp=$4} END {print "EC2_TAG_KEY=" tmp}' ${i}.txt)
declare $(awk '{tmp=$5} END {print "EC2_TAG_VALUE=" tmp}' ${i}.txt)

## AWS region and credentails
region=${REGION}

## Route53 zone name and record name
zone_name=${ZONE_NAME}
rec_name=${RECORD_NAME}

## Ec2-tag
ec2_tag_key=${EC2_TAG_KEY}
ec2_tag_value=${EC2_TAG_VALUE}

## Making Inventory file
my_inventory=myhosts
cat > $my_inventory <<EOF
[localhost]
localhost ansible_connection=local ansible_python_interpreter=python
EOF

## Printing Variable values
echo "==========================="
echo -e "zone_name=$zone_name \nRegion=$region \nRecorName=$rec_name \nec2_tag_key=$ec2_tag_key \nec2_tag_value=$ec2_tag_value"
echo -e "route53_repo=$route53_repo \nroute53_file=$route53_file"
echo "==========================="

## Creating Yaml file
cat > route53_${i}.yml <<EOF
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
ansible-playbook -i $my_inventory route53_${i}.yml -vv

done
