provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "bad_sg" {
  name        = "bad-security-group"
  description = "Security group that is very insecure"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ เปิด SSH ให้ทั้งโลก
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ เปิด HTTP public
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ Egress กว้างเกินไป
  }
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "my-super-public-bucket-12345"

  acl    = "public-read"         # ❌ Bucket เป็น public
}

resource "aws_s3_bucket_server_side_encryption_configuration" "missing" {
  bucket = aws_s3_bucket.bad_bucket.id
  # ❌ ไม่มี encryption configuration (บาง policy จะจับ)
}
