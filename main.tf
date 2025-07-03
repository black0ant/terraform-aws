provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "use1"
  region = "us-east-1"
}
 
module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
 
module "ec2" {
  source        = "./modules/ec2"
  ami           = "ami-05ffe3c48a9991133"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.subnet_id
  vpc_id        = module.vpc.vpc_id
  name          = "TerraformEC2"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "terraform-demo-bucket"
  providers = {
    aws = aws.use1
  }
}