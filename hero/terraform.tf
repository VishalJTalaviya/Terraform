terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.91.0"
    }
  }

  backend "s3" {
    
    bucket = "vishal-state-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "vishal-state-table"
  }
}