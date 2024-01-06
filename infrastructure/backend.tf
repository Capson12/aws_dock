terraform {
  backend "s3" {
    bucket = "smtxglobal"
    key = "tfstatefile"
    region = "eu-west-2"
  }
}