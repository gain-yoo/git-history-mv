provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "myiam" {
  count = 3
  name  = "yooga.${count.index}"
}
