## ECR Terraform

This repository will setup a private ecr repository and will have two lifecycles
* untagged images will expire in 1 day
* idle images will expire in 14 days

Once an image is build we can push it with the script
```
./pushImagesToEcr.sh
```
