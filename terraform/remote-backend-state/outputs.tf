output "queue_arns" {
  value = aws_dynamodb_table.this[*].arn
}
