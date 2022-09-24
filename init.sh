#!/usr/bin/env bash

echo "Making Root CA..."
openssl req -newkey rsa:4096 -nodes -keyout ca-key.pem -sha384 -x509 -days 365 -out ca-crt.pem -subj /C=XX/ST=YY/O=RootCA

echo "Making Intermediate CA..."
openssl req -newkey rsa:3072 -nodes -keyout int-key.pem -new -sha384 -out int-csr.pem -subj /C=XX/ST=YY/O=IntermediateCA
openssl x509 -req -days 360 -in int-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out int-crt.pem

echo "Making User Cert..."
openssl req -newkey rsa:2048 -nodes -keyout usr-key.pem -new -sha256 -out usr-csr.pem -subj /C=XX/ST=YY/O=LockCmpXchg8b
openssl x509 -req -days 360 -in usr-csr.pem -CA int-crt.pem -CAkey int-key.pem -CAcreateserial -out usr-crt.pem

echo ""
echo "Making Chain..."
cat ca-crt.pem int-crt.pem > chain.pem

echo ""
echo "Verfying UserCert via RootCA..."
openssl verify -CAfile ca-crt.pem usr-crt.pem

echo ""
echo "Verfying UserCert via IntermediateCA..."
openssl verify -CAfile int-crt.pem usr-crt.pem

echo ""
echo "Verfying UserCert via chain..."
openssl verify -CAfile chain.pem usr-crt.pem
