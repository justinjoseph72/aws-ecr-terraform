#!/usr/bin/env bash
set -e

# get the account id
aws_account_id=$(aws sts get-caller-identity --query 'Account' | sed 's/"//g')
# get auth token and login to ecr using docker
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.eu-west-2.amazonaws.com

MONGO_IMAGE="mongo:8.3"

image_id=$(docker image ls ${MONGO_IMAGE} --format "{{.ID}}")
repository_uri=$(aws ecr describe-repositories --repository-names --output json mongodb | jq -r '.repositories[0].repositoryUri')

# tagging the image with ECR repository
docker tag "${image_id}" "${repository_uri}:latest"

docker push "${repository_uri}:latest"