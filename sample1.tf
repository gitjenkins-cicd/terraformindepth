provider "aws" {
    region="ap-northeast-1"
}

resource "aws_security_group" "instance" {
    name="terrform-example-instance"

    ingress {
        from_port=8080
        to_port=8080
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]

    }
    lifecycle {
      create_before_destroy=true
    }

}



resource "aws_instance"  "example1" {
    ami="ami-001f026eaf69770b4"
    instance_type="t2.micro"
    count = 2
    private_ip="${lookup(var.ips,count.index)}"
    vpc_security_group_ids=["${aws_security_group.instance.id}"]
    tags = {
        Name="terraform-example-instance"
    }
    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
    lifecycle {
      create_before_destroy=true   
    }
}

#output "public_ip" {
#    #value="${aws_instance.example1.public_ip}"
#    value="${aws_instance.example1[count.index]}"
#
#}

