resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.project_name}-vpc"
    "kubernetes.io/cluster/three-tier-project" = "shared"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones_public)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.availability_zones_public[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public${count.index}"
    "kubernetes.io/cluster/three-tier-project" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = var.private_availability_zone[count.index]
  tags = {
    Name = "${var.project_name}-private"
    "kubernetes.io/cluster/three-tier-project" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count         = length(var.availability_zones_public)
  subnet_id     = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-private-rt"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
  count         = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "allow_ssh"
  description = "Security group allowing SSH communication"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this for better security
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowSSH"
  }
}

resource "aws_security_group" "main_server" {
  vpc_id      = aws_vpc.main.id
  name        = "main_server"
  description = "Security group allowing SSH, HTTP (port 8080), and custom port 9000 communication"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this for better security
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-server"
  }
}
