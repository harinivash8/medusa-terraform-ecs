resource "aws_db_instance" "postgres" {
  identifier         = "medusa-postgres"
  engine             = "postgres"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  name               = "medusadb"
  username           = var.db_username
  password           = var.db_password
  publicly_accessible = true
  skip_final_snapshot = true
}
