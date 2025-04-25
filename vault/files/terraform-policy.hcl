# Policy for terraform AppRole
path "secret/PLATFORM/*" {
    capabilities = ["read"]
}
 
path "auth/token/create" {
    capabilities = ["create", "read", "update", "list"]
}

# Working with OIDC auth mathod keycloak/ roles
path "auth/keycloak/role/*" {
    capabilities = ["create", "read", "update", "list"]
}

# Working with OIDC auth mathod avanpost/ roles
path "auth/avanpost/role/*" {
    capabilities = ["create", "read", "update", "list"]
}
 
# Create consul tokens
path "consul/creds/*" {
   capabilities = ["read"]
}
 
# Manage roles
path "consul/roles/*" {
   capabilities = ["read", "create", "update", "delete", "list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
 
# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
 
path "consul/config/access" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
 
# List enabled secrets engine
path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Work with pki secrets engine
path "pki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
