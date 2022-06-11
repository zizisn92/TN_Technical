data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220426.0-x86_64-gp2"]
  }

  owners = ["137112412989"] # Canonical
}