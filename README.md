# My sample project

My sample project divided in task to work with .NET and Azure 

## Task 1

### Scope

Simple dotnet endpoint which returns app start time in UTC

### Requirements
- Windows 10/11 or Windows Server or any linux distribution
- .NET SDK 10.0.0 has to be installed
- Docker and Docker Compose needs to be installed to build image, alternativley use dotnet runner to run code only


### Deploy
1. to run with docker:
#### Docker
```
docker compose up -d
```

#### Windows 
```
dotnet run --launch-profile "http"
```

2. Open browser on same machine and access ```http://localhost:8080/pong``` it should return application start time in UTC


### Stop
#### Docker 
run:
```
docker compose down
```
#### Windows 
press ```ctrl + c``` in same console where dotnet run was executed

## Task 2

### Requirements
- Windows 10/11 or Windows Server 
- Admin privilages to be able to execute shell script
- Internet connection

### Assumptions
- Script will redownload github repository each run
- Approach of this script to be as part of CI/CD process, script is safe to re-run but site pool will be redeployed each time 
- In case any changes needed to be made in path's script variables should be modified

### Run endpoint in windows IIS

- Copy content from task2 folder to Windows machine to user space
- execute `run.bat` in order to run script
- Accept admin premission dialogue 
- once script finish, visit link in the end of output it should give UTC startup time of app


## Task 3

## Scope

Terraform code provisions infrastructure and container deployment:

- Azure resource group, network, public IP, and Linux VM
- Docker installation if missing
- Repository clone on the VM
- Image build from `task1/Dockerfile`
- Public access to api endpoint from task1

## File layout

- `1-main.tf`: Terraform version, provider, backend
- `2-network.tf`: resource group, VNet, subnet, NSG, NIC, public IP
- `3-compute.tf`: Linux VM
- `4-deployment.tf`: VM extension that runs the idempotent container bootstrap
- `5-variables.tf`: inputs
- `6-outputs.tf`: useful outputs
- `scripts/bootstrap-container.sh.tftpl`: idempotent container bootstrap script

## Prerequisites

- Terraform has to be installed
- Azure CLI authenticated 
- An Azure Storage account and blob container created manually for the Terraform backend
- An SSH public key for VM access, generate rsa key's

## Backend setup

Create the backend resources manually first. Azure calls the state store a blob container rather than a bucket.

Example:

```bash
az group create --name rg-tfstate --location westeurope
az storage account create \
  --name mystatetask3acct \
  --resource-group rg-tfstate \
  --location westeurope \
  --sku Standard_LRS --encryption-services blob 
az storage container create \
  --name tfstate \
  --account-name mystatetask3acct
```

## Execution

1. Copy `terraform.tfvars.example` to `terraform.tfvars`, add backed information to 1-main.tf like in example `backend.tfvars.example`, container should match created in previous step in order to upload terrafrom state to encrypted container
2. Fill all fields in terraform.tfvars
3. Review the plan.
4. Apply the configuration.
5. Output should give public accessible api endpoint from task1 

Example:

```bash
cd task3
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```


## Destroy

To destroy deployed project run in the same directory:

```bash
cd task3
terraform destroy
```

## Troubleshooting

If you have trouble creating container 

```Subscription MY_SUBSCRIPTION_ID_HERE was not found.```

Check if you able to create a storage account in Azure Portal
