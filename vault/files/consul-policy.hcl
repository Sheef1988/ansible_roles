path "auth/token/create" {
    capabilities = ["create", "read", "update", "list"]
}

# Create consul tokens
path "consul/creds/*" {
   capabilities = ["read"]
}

# Work with pki secrets engine
path "pki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
