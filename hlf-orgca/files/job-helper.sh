#!/bin/bash
apt-get update -y 
apt-get install curl -y
apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
apt-get remove curl -y
apt-get remove unzip -y

export FABRIC_CA_CLIENT_HOME=/shared
cd /shared
mkdir org-ca
aws s3 cp s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca-cert.pem /shared/tls-root-cert/tls-ca-cert.pem

# Enroll the CA admin
fabric-ca-client enroll -d -u \
  https://rcaadmin:rcaadminpw@$ORGCA_URL:$ORGCA_PORT \
  --tls.certfiles tls-root-cert/tls-ca-cert.pem \
  --mspdir org-ca/rcaadmin/msp

# Upload artifact
cp $FABRIC_CA_CLIENT_HOME/org-ca/rcaadmin/msp/keystore/*_sk $FABRIC_CA_CLIENT_HOME/org-ca/rcaadmin/msp/keystore/key.pem
aws s3 cp $FABRIC_CA_CLIENT_HOME/org-ca/rcaadmin/msp s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/org-ca/rcaadmin/msp --recursive
