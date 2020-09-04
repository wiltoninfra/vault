

resource "aws_dynamodb_table" "dynamodb-vault-table" {
  name           = "${var.dynamoTable}"
  read_capacity  = 1
  write_capacity = 1
    hash_key       = "Path"
    range_key      = "Key"
    attribute      = [
        {
            name = "Path"
            type = "S"
        },
        {
            name = "Key"
            type = "S"
        }
    ]
  tags {
    Name        = "vault-dynamodb-table"
    Environment = "dev"
  }
}