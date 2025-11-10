resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.database_name}-${var.environment}-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    database = var.database_name
    host     = var.db_host
    port     = 1433
  })
}

# Create SSM document for database operations
resource "aws_ssm_document" "create_database" {
  name          = "${var.database_name}-${var.environment}-create-db"
  document_type = "Command"
  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Create SQL Server database and user"
    parameters = {
      dbHost = {
        type        = "String"
        description = "Database host"
      }
      dbName = {
        type        = "String"
        description = "Database name"
      }
      dbUser = {
        type        = "String"
        description = "Database user"
      }
      masterUser = {
        type        = "String"
        description = "Master username"
      }
      masterPassword = {
        type        = "String"
        description = "Master password"
      }
      userPassword = {
        type        = "String"
        description = "User password"
      }
    }
    mainSteps = [
      {
        action = "aws:runPowerShellScript"
        name   = "createDatabase"
        inputs = {
          runCommand = [
            "Install-Module -Name SqlServer -Force -AllowClobber",
            "Import-Module SqlServer",
            "$securePassword = ConvertTo-SecureString -String '{{masterPassword}}' -AsPlainText -Force",
            "$credential = New-Object System.Management.Automation.PSCredential('{{masterUser}}', $securePassword)",
            "Invoke-Sqlcmd -ServerInstance '{{dbHost}}' -Credential $credential -Query \"CREATE DATABASE {{dbName}}\"",
            "Invoke-Sqlcmd -ServerInstance '{{dbHost}}' -Credential $credential -Query \"USE master; CREATE LOGIN {{dbUser}} WITH PASSWORD = '{{userPassword}}'\"",
            "Invoke-Sqlcmd -ServerInstance '{{dbHost}}' -Credential $credential -Query \"USE master; GRANT ALTER ANY LOGIN TO {{masterUser}}\"",
            "Invoke-Sqlcmd -ServerInstance '{{dbHost}}' -Credential $credential -Database '{{dbName}}' -Query \"CREATE USER {{dbUser}} FOR LOGIN {{dbUser}}\"",
            "Invoke-Sqlcmd -ServerInstance '{{dbHost}}' -Credential $credential -Database '{{dbName}}' -Query \"ALTER ROLE db_owner ADD MEMBER {{dbUser}}\""
          ]
        }
      }
    ]
  })
}

# Run the SSM document
resource "aws_ssm_association" "create_database" {
  name = aws_ssm_document.create_database.name
  parameters = {
    dbHost         = var.db_host
    dbName         = var.database_name
    dbUser         = var.db_username
    masterUser     = var.master_username
    masterPassword = var.master_password
    userPassword   = random_password.db_password.result
  }
  targets {
    key    = "InstanceIds"
    values = ["i-1234567890abcdef0"]  # Replace with your EC2 instance ID that has SQL Server tools
  }
} 

resource "aws_route53_record" "db" {
  zone_id = var.hosted_zone_id
  name = "${var.environment}.${var.database_name}-db.${var.domain_name}"
  type = "CNAME"
  ttl = "300"
  records = [var.db_host]
}

output "db_dns_record" {
  description = "The DNS record for the database"
  value       = aws_route53_record.db.fqdn
}