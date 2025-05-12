terraform {
  backend "s3" {
    bucket = "b59-tf-state-bucket"
    key    = "b59/eks-learning/terraform.tfstate"
    region = "us-east-1"
  }
}
