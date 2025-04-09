resource "aws_s3_bucket" "remote_s3" {
  bucket = "vishal-state-bucket"

  tags = {
    Name        = "vishal-state-bucket"
  }
}