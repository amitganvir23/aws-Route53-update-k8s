# all-cluster-docker Docker file to make docker container to updater Route 53 with the required entries from the list

  - ROUTE53_REPO=ssh://git@bitbucket.gmail.com/gltin/glt-infra-route53-update.git
  - ROUTE53_FILE=route53_name_list
  - AWS_SECRET_ACCESS_KEY="FROM Kubernetes Secrets"
  - AWS_ACCESS_KEY_ID="FROM Kubernetes Secrets"
  - ROUTE53_FILE List Name Should be like this: #REGION #ZONE_NAME #RECORD_NAME #EC2_TAG_KEY #EC2_TAG_VALUE
  - Example: us-west-2 glt-qa.com cb-kernel.glt-qa.com Name glt-qa-kernel-Server
  - Kubernetes Yaml file: route53_update_cluster.yaml


##### Process

```shell
# Clone repository

# To Run container manually
docker run -it -e AWS_SECRET_ACCESS_KEY='YourSecRetACCESSKEy' -e  AWS_ACCESS_KEY_ID='YOuRAccEssKey' -e ROUTE53_REPO='ssh://git@bitbucket.gmail.com/gltin/glt-infra-route53-update.git' -e ROUTE53_FILE='route53_name_list' 953030164212.dkr.ecr.us-east-1.amazonaws.com/glt-route53-dns:cluster2 bash

```
