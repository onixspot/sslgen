#!/usr/bin/env bash

echo ""
echo "Alternate Intermedate CA (using -addtrust anyExtendedKeyUsage)"
echo ""

echo "Making IntermediateCAWithTrust..."
openssl req -newkey rsa:3072 -nodes -keyout int-key2.pem -new -sha384 -out int-csr2.pem -subj /C=XX/ST=YY/O=IntermediateCAWithTrust
openssl x509 -req -days 360 -in int-csr2.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out int-crt2.pem -addtrust anyExtendedKeyUsage

echo "Making AnotherUser Cert..."
openssl req -newkey rsa:2048 -nodes -keyout usr-key2.pem -new -sha256 -out usr-csr2.pem -subj /C=XX/ST=YY/O=LockCmpXchg8b_2
openssl x509 -req -days 360 -in usr-csr2.pem -CA int-crt2.pem -CAkey int-key2.pem -CAcreateserial -out usr-crt2.pem

echo ""
echo "Verfying AnotherUserCert via IntermediateCAWithTrust..."
openssl verify -CAfile int-crt2.pem usr-crt2.pem
