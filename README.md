# How to Update Route 53, Use following steps
  - Step1: Pull/Clone this current repository (ssh://git@bitbucket.gmail.com/gltin/glt-infra-route53-update.git)
  
  - Step2: Update your Route 53 list in file "route53_name_list" and commit the changes in the repository. 
  	- (Put an entry in a file with the correct format and space - #REGION #ZONE_NAME #RECORD_NAME #EC2_TAG_KEY #EC2_TAG_VALUE)
    
  - Step3: Go to Jenkins jobs https://jenkins.gl-poc.com/view/K8S-Jobs/job/Route53-Update-Cluster-K8S/ and Click on "Build with Parameters" and then "build" it 
  	- (Note: Don't worry, Parameters already set by default)
    
  - Step4: Verify the changes in Route53
  
  - Note: Jenkins job is scheduled to run every 2 hours.

# -------------------------------------------------------------------------



# Default parameters fixed and can be changed from Jenkins parameter, only if needed:

  - ROUTE53_REPO=ssh://git@bitbucket.gmail.com/gltin/glt-infra-route53-update.git
  - ROUTE53_FILE=route53_name_list
  - AWS_SECRET_ACCESS_KEY="FROM Kubernetes Secrets"
  - AWS_ACCESS_KEY_ID="FROM Kubernetes Secrets"
  - ROUTE53_FILE List Name Should be like this: #REGION #ZONE_NAME #RECORD_NAME #EC2_TAG_KEY #EC2_TAG_VALUE
  	- Example: us-west-1 glt-test.com test5.glt-test.com Couchbase-Cluster glt-test
  - Kubernetes Yaml file: route53_update_cluster.yaml


