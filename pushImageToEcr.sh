#!/usr/bin/env bash
set -e

# get the account id
aws_account_id=$(aws sts get-caller-identity --query 'Account' | sed 's/"//g')
# get auth token and login to ecr using docker
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.eu-west-2.amazonaws.com

image_id=$(docker images --filter 'label=app-name=home-inventory' --filter 'dangling=false' --format "{{.Repository}}:{{.Tag}}|{{.ID}}" | grep -v 'dkr.ecr.' | grep 'latest' | awk -F '|' '{print $2}')
repository_uri=$(aws ecr describe-repositories --repository-names --output json home-inventory | jq -r '.repositories[0].repositoryUri')

# tagging the image with ECR repository
docker tag "${image_id}" "${repository_uri}:latest"

tag_to_push=$(docker images --filter 'label=app-name=home-inventory' --filter 'dangling=false' --format "{{.Repository}}:{{.Tag}}" | grep 'dkr.ecr.' | grep 'latest')

docker push "${tag_to_push}"