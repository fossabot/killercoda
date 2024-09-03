#!/bin/bash
set -x 
echo starting...
mkdir ~/solutions

snap install opentofu --classic

# Install HCL2JSON
HCL2JSON_VERSION="0.6.3"
wget "https://github.com/tmccombs/hcl2json/releases/download/v${HCL2JSON_VERSION}/hcl2json_linux_amd64" -O /tmp/hcl2json
mv /tmp/hcl2json /usr/local/bin/hcl2json
chmod +x /usr/local/bin/hcl2json

# Install EJSON
EJSON_VERSION="1.5.2"
wget "https://github.com/Shopify/ejson/releases/download/v${EJSON_VERSION}/ejson_${EJSON_VERSION}_linux_amd64.deb" -O /tmp/ejson.deb
sudo dpkg -i /tmp/ejson.deb
sudo apt-get install -f

# Install SOPS
SOPS_VERSION="v3.9.0"
curl -LO "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64"
mv "sops-${SOPS_VERSION}.linux.amd64" /usr/local/bin/sops
chmod +x /usr/local/bin/sops

mkdir ~/scenario
cd ~/scenario

# Manifests
cat << 'EOF' > ~/scenario/variables.tf
variable "postgres_user" {
  description = "The PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "The PostgreSQL password"
  type        = string
  sensitive   = true
}
EOF

cat << 'EOF' > ~/scenario/main.tf
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "postgres" {
  name       = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.20"

  set_sensitive {
    name  = "global.postgresql.auth.postgresPassword"
    value = var.postgres_password
  }
}
EOF

touch /tmp/finished
