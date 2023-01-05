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

aws s3 cp s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca-cert.pem $FABRIC_CA_CLIENT_HOME/tls-root-cert/tls-ca-cert.pem
aws s3 cp  s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca $FABRIC_CA_CLIENT_HOME/tls-ca --recursive

# Register and enroll the organization CA bootstrap identity with the TLS CA
fabric-ca-client register -d \
  --id.name rcaadmin \
  --id.secret rcaadminpw \
  -u https://{{ .Values.global.orgName }}-tlsca:7054 \
  --tls.certfiles tls-root-cert/tls-ca-cert.pem \
  --mspdir tls-ca/tlsadmin/msp

fabric-ca-client enroll -d \
  -u https://rcaadmin:rcaadminpw@{{ .Values.global.orgName }}-tlsca:7054 \
  --tls.certfiles tls-root-cert/tls-ca-cert.pem \
  --enrollment.profile tls \
  --csr.hosts '{{ .Values.global.orgName }}-orgca' \
  --mspdir tls-ca/rcaadmin/msp

mkdir /shared/tls
cp $FABRIC_CA_CLIENT_HOME/tls-ca/rcaadmin/msp/signcerts/cert.pem /shared/tls/cert.pem
cp $FABRIC_CA_CLIENT_HOME/tls-ca/rcaadmin/msp/keystore/*_sk /shared/tls/key.pem
aws s3 cp $FABRIC_CA_CLIENT_HOME/tls-ca/rcaadmin/msp  s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca/rcaadmin/msp --recursive
