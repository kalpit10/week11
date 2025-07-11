resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP traffic only on 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  root_block_device {
    encrypted = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    sed -i -e 's/80/8080/' /etc/apache2/ports.conf
    echo "Hello Secure World" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}
