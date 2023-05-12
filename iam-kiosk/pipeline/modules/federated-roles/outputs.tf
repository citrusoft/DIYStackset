output "saml_role" {
  value       = aws_iam_role.saml_integration_role.arn
}

output "partner_role" {
  value       = aws_iam_role.partner_role.arn
}
