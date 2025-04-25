# Grant full permissions to admins
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}