# Read-only policy for Jenkins user, which one will connect to vault
path "secret/*" {
    capabilities = ["read"]
}
