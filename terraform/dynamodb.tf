resource "aws_dynamodb_table" "visitor_counter_table" {
  billing_mode   = "PROVISIONED"
  hash_key       = "var_name"
  name           = "visitor-counter"
  read_capacity  = 1
  table_class    = "STANDARD"
  write_capacity = 1
  attribute {
    name = "var_name"
    type = "S"
  }
}