# single-docker Docker file to make docker container to update Route 53 for one record
  - REGION="YourRegion"
  - ZONE_NAME="YourZoneName"
  - RECORD_NAME="YourRecordName"
  - EC2_TAG_KEY="YourEC2_Tag_Kye"
  - EC2_TAG_VALUE="YourEC2_Tag_Value"
  - AWS_SECRET_ACCESS_KEY="FROM Kubernetes Secrets"
  - AWS_ACCESS_KEY_ID="FROM Kubernetes Secrets"
  - Kubernetes Yaml file: route53_update.yaml

##### Process

```shell
# Clone repository

# To Run container manually
docker run -it -e REGION="YourRegion" -e ZONE_NAME="YourZoneName" -e RECORD_NAME="YourRecordName" -e EC2_TAG_KEY="YourEC2_Tag_Kye" -e EC2_TAG_VALUE="YourEC2_Tag_Value" -e AWS_SECRET_ACCESS_KEY='YourSecRetACCESSKEy' -e  AWS_ACCESS_KEY_ID='YOuRAccEssKey' 953030164212.dkr.ecr.us-east-1.amazonaws.com/glt-route53-dns:latest bash

```
