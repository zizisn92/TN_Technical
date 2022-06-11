2 lenh nay tao roi ko chay lai
aws s3api create-bucket --region us-east-1 --bucket 179623033511_terraform_states

aws dynamodb create-table --region us-east-1 --attribute-definitions AttributeName=LockID,AttributeType=S --table-name 179623033511_terraform_statelock --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput WriteCapacityUnits=5,ReadCapacityUnits=5

chay bat dau tu day

terraform init \
    -backend-config "key=terraform/us-east-1/dev/tranning.tfstate" \
    -backend-config "bucket=179623033511-terraform-states" \
    -backend-config "dynamodb_table=179623033511_terraform_statelock" \
    -backend-config "region=us-east-1"

terraform apply --auto-approve
