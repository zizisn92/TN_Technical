resource "aws_instance" "this" {
   ami             = data.aws_ami.linux.id
   instance_type   = var.instance_type
   user_data = file("./modules/ec2/web.sh")
   subnet_id = var.subnet_id
   key_name = var.key_name

   associate_public_ip_address = var.associate_public_ip_address
#    iam_instance_profile = var.instance_profile 
   disable_api_termination = var.enable_api_termination
   vpc_security_group_ids   = ["${var.security_group}"]
   tags = {
       Name = "${var.environment}-${var.application}"
       Environment  = "${var.environment}"        
       DateTime = "${timestamp()}"
   }
}