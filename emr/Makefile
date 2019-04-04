include config-aws.mk # Vars related to AWS credentials and services used
include config-emr.mk # Vars related to type and size of EMR cluster
include config-run.mk # Vars related to applications

ifeq ($(USE_SPOT),true)
MASTER_BID_PRICE:=BidPrice=${MASTER_PRICE},
WORKER_BID_PRICE:=BidPrice=${WORKER_PRICE},
endif

ifdef COLOR
COLOR_TAG=--tags Color=${COLOR}
endif

ifndef CLUSTER_ID
CLUSTER_ID=$(shell if [ -e "cluster-id.txt" ]; then cat cluster-id.txt; fi)
endif

upload-files: bootstrap.sh
	aws s3 cp ./bootstrap.sh ${S3_URI}/scripts/bootstrap.sh

create-cluster: upload-files
	aws emr create-cluster --name "${NAME}" ${COLOR_TAG} \
--release-label emr-5.23.0 \
--output text \
--use-default-roles \
--configurations "file://$(CURDIR)/cluster-configurations.json" \
--log-uri ${S3_URI}/logs \
--ec2-attributes KeyName=${EC2_KEY},SubnetId=${SUBNET_ID},EmrManagedMasterSecurityGroup=${SECURITY_GROUP},EmrManagedSlaveSecurityGroup=${SECURITY_GROUP} \
--applications Name=Ganglia Name=Hadoop Name=Spark Name=Zeppelin \
--instance-groups \
'Name=Master,${MASTER_BID_PRICE}InstanceCount=1,InstanceGroupType=MASTER,InstanceType=${MASTER_INSTANCE}' \
'Name=Workers,${WORKER_BID_PRICE}InstanceCount=${WORKER_COUNT},InstanceGroupType=CORE,InstanceType=${WORKER_INSTANCE}' \
--bootstrap-actions \
Name=Install,Path=${S3_URI}/scripts/bootstrap.sh,Args=[${S3_URI},${RPMS_VERSION}] \
| tee cluster-id.txt


terminate-cluster:
	aws emr terminate-clusters --cluster-ids ${CLUSTER_ID}
	rm -f cluster-id.txt
	rm -f last-step-id.txt

proxy:
	aws emr socks --cluster-id ${CLUSTER_ID} --key-pair-file "${HOME}/${EC2_KEY}.pem"

ssh:
	aws emr ssh --cluster-id ${CLUSTER_ID} --key-pair-file "${HOME}/${EC2_KEY}.pem"

get-logs:
	@aws emr ssh --cluster-id $(CLUSTER_ID) --key-pair-file "${HOME}/${EC2_KEY}.pem" \
		--command "rm -rf /tmp/spark-logs && hdfs dfs -copyToLocal /var/log/spark/apps /tmp/spark-logs"
	@mkdir -p  logs/$(CLUSTER_ID)
	@aws emr get --cluster-id $(CLUSTER_ID) --key-pair-file "${HOME}/${EC2_KEY}.pem" --src "/tmp/spark-logs/" --dest logs/$(CLUSTER_ID)

.PHONY: get-logs
