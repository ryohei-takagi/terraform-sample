resource "aws_rds_cluster_parameter_group" "sample" {
  name = "sample-cluster-paameter-group-${terraform.workspace}"
  family = "aurora-mysql5.7"

  parameter {
    name = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name = "time_zone"
    value = "Asia/Tokyo"
  }
}

resource "aws_db_parameter_group" "sample" {
  name = "sample-db-paameter-group-${terraform.workspace}"
  family = "aurora-mysql5.7"
}

resource "aws_db_subnet_group" "sample" {
  name = "sample-db-subnet-group-${terraform.workspace}"
  subnet_ids = [
    data.terraform_remote_state.network.outputs.sample_vpc_private_subnet_0_id,
    data.terraform_remote_state.network.outputs.sample_vpc_private_subnet_1_id,
  ]
}

data "aws_iam_policy" "aurora_monitoring_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "aurora_monitoring" {
  source_json = data.aws_iam_policy.aurora_monitoring_policy.policy
}

module "aurora_monitoring_role" {
  source = "../../modules/iam_role"
  name = "aurora_monitoring_role"
  identifier = "monitoring.rds.amazonaws.com"
  policy = data.aws_iam_policy_document.aurora_monitoring.json
}

module "aurora_sg" {
  source = "../../modules/securitygroup"
  name = "sample-db-${terraform.workspace}"
  vpc_id = data.terraform_remote_state.network.outputs.sample_vpc_id
  port = 3306
  cider_blocks = [data.terraform_remote_state.network.outputs.sample_vpc_cider_block]
}

resource "aws_rds_cluster" "sample" {
  cluster_identifier = "sample-${terraform.workspace}"
  master_username = "sample"
  master_password = "initial_password" # 手動で変更すること
  database_name = "sample"
  backup_retention_period = 7
  preferred_backup_window = "09:30-10:00" # UTC
  preferred_maintenance_window = "wed:10:30-wed:11:00" # UTC
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.07.1"
  port = 3306
  vpc_security_group_ids = [module.aurora_sg.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.sample.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.sample.name
  storage_encrypted = true
  deletion_protection = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  skip_final_snapshot = false
  final_snapshot_identifier = "sample-${terraform.workspace}-final-snapshot"

  lifecycle {
    ignore_changes = [master_password]
  }
}

resource "aws_rds_cluster_instance" "sample" {
  count = var.cluster_instance_count
  identifier = "sample-${terraform.workspace}-${count.index}"
  cluster_identifier = aws_rds_cluster.sample.id
  instance_class = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.sample.name
  db_parameter_group_name = aws_db_parameter_group.sample.name
  monitoring_role_arn = module.aurora_monitoring_role.iam_role_arn
  monitoring_interval = 60
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.07.1"
  ca_cert_identifier = "rds-ca-2019"

  # 変更をすぐに適用する場合
  # apply_immediately = true
}