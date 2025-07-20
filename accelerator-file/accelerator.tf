// GA needs to know where the ALBs are located, so we need to define providers for each region.


## need to provide aws providers and region on every folder else tf does not know where to apply 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # ✅ Use any valid region like ap-south-1, us-east-1, etc.
}
 

# Providers for both regions
provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}


# getting alb ARN from diff folder state files 

data "terraform_remote_state" "mumbai" {
  backend = "local"
  config = {
    path = "../mumbai/terraform.tfstate"
  }
}

data "terraform_remote_state" "ireland" {
  backend = "local"
  config = {
    path = "../ireland/terraform.tfstate"
  }
}


// as GA knew region and ALB ARN, it can create the endpoint group for each region

resource "aws_globalaccelerator_accelerator" "this" {
  name            = "multi-region-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  tags = {
    Name = "multi-region-accelerator"
  }
}

// listens 

resource "aws_globalaccelerator_listener" "this" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  protocol        = "TCP"
  port_range {
    from_port = 80
    to_port   = 80
  }
}

// endpoint in region being attached with thier ALBs ARN

resource "aws_globalaccelerator_endpoint_group" "mumbai" {
  listener_arn          = aws_globalaccelerator_listener.this.id
  endpoint_group_region = "ap-south-1"

  endpoint_configuration {
    endpoint_id = data.terraform_remote_state.mumbai.outputs.alb_arn
    weight      = 128
  }
}

resource "aws_globalaccelerator_endpoint_group" "ireland" {
  listener_arn          = aws_globalaccelerator_listener.this.id
  endpoint_group_region = "eu-west-1"

  endpoint_configuration {
    endpoint_id = data.terraform_remote_state.ireland.outputs.alb_arn
    weight      = 128
  }
}
