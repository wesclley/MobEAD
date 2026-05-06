provider "aws" {
  region = "us-east-1"
}

# 1. Criar Security Group (Firewall) para liberar RDP e WinRM
resource "aws_security_group" "sg_windows" {
  name        = "sg_projeto_unidade4"
  description = "Liberar portas RDP e WinRM"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Provisionar a VM com Windows Server 2019
resource "aws_instance" "windows_server" {
  ami           = "ami-0b0a8869c3a3721d5" # AMI Windows Server 2019
  instance_type = "t2.micro"              # Free Tier
  security_groups = [aws_security_group.sg_windows.name]

  tags = {
    Name = "Windows-Server-IIS-Ansible"
  }

  # 3. Script User Data para habilitar o WinRM automaticamente na inicialização
  user_data = <<-EOF
    <powershell>
    winrm quickconfig -q
    winrm set winrm/config/service/auth '@{Basic="true"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    netsh advfirewall firewall add rule name="WinRM 5986" dir=in action=allow protocol=TCP localport=5986
    </powershell>
  EOF
}

# Exibir o IP público gerado no final
output "public_ip" {
  value = aws_instance.windows_server.public_ip
}