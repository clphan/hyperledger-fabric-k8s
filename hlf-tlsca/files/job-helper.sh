#!/bin/bash
apt-get update -y 
apt-get install curl -y
apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
apt-get remove curl -y
apt-get remove unzip -y

while [ ! -f /shared/ca-cert.pem ]
do
  sleep 2
done

export FABRIC_CA_CLIENT_HOME=/shared
cd /shared
mkdir tls-root-cert
mkdir tls-ca
cp /shared/ca-cert.pem /shared/tls-root-cert/tls-ca-cert.pem

# Signed cert and private key for the TLS CA bootstrap admin identity stored under tls-ca/tlsadmin/msp
fabric-ca-client enroll -d -u \
  https://$CA_USER:$CA_PASSWORD@{{ .Values.global.orgName }}-{{ .Values.global.component }}:{{ .Values.node.image.containerPort }} \
  --tls.certfiles tls-root-cert/tls-ca-cert.pem \
  --enrollment.profile tls \
  --mspdir tls-ca/tlsadmin/msp

fabric-ca-client enroll -d -u \
  https://$CA_USER:$CA_PASSWORD@template-tlsca:7054 \
  --tls.certfiles tls-root-cert/tls-ca-cert.pem \
  --enrollment.profile tls \
  --mspdir tls-ca/tlsadmin/msp

aws s3 cp /shared/ca-cert.pem s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca-cert.pem
aws s3 cp /shared/tls-ca s3://$BUCKET_ARTIFACTS_SHARED/$ORG_NAME/tls-ca --recursive
