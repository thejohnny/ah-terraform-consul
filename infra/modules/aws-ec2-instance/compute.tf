resource "aws_security_group" "main" {
  name        = "${var.resource_prefix}-sg"
  description = "${var.resource_prefix} security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.ec2_ip_allowlist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  count = var.ec2_node_count

  ami                  = data.aws_ami.ubuntu_noble_24_04.id
  instance_type        = var.ec2_instance_type
  subnet_id            = element(data.aws_subnets.default.ids, count.index)
  key_name             = var.ec2_aws_key_pair_name
  iam_instance_profile = aws_iam_instance_profile.main.name

  user_data_replace_on_change = true
  user_data_base64            = var.ec2_user_data_base64

  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = var.resource_prefix
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ec2" {
  name        = "${var.resource_prefix}-cloud-auto-join"
  description = "IAM policy to allow describing EC2 instance for cloud auto-join"
  policy      = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_role" "main" {
  name_prefix        = "${var.resource_prefix}-"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ec2.arn
}

resource "aws_iam_instance_profile" "main" {
  path = "/"
  role = aws_iam_role.main.name
}