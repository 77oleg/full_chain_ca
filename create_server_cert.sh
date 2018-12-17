#!/bin/bash
# Basic settings

pub_path='pub'
tmp_path='tmp'

cn_name='site.name.dom'

ca_name='server_ca_cert'
im_name='server_ca_im_cert'
sr_name=''$cn_name'_cert'

ca_days=3650
im_days=3650

ca_subj="/CN=Your CA name here"
im_subj="/CN=Your IM name here"
crt_subj="/C=RU/ST=State/L=Land/O=Your Organization/OU=Organization Unit/CN=$cn_name"

pkcs12_pwd='password here'

mkdir $pub_path
mkdir $tmp_path

mkdir $tmp_path/srv_db
mkdir $tmp_path/srv_db/certs
mkdir $tmp_path/srv_db/newcerts
echo 2>$tmp_path/srv_db/index.txt
echo 01 > $tmp_path/srv_db/serial

# Root self signed server certificate

#/usr/bin/openssl req -new -newkey rsa:4096 -nodes -keyout "$tmp_path/$ca_name".key -x509 -days $ca_days -subj "$ca_subj" -out "$tmp_path/$ca_name".crt -config conf_req.config

#openssl rsa  -noout -text -in "$tmp_path/$ca_name".key
#openssl x509 -noout -text -in "$tmp_path/$ca_name".crt

# Converting to pem format

#openssl x509 -in "$tmp_path/$ca_name".crt -out "$tmp_path/$ca_name".der -outform DER
#openssl x509 -in "$tmp_path/$ca_name".der -inform DER -out "$tmp_path/$ca_name".pem -outform PEM

# IM's private key and Certificate Signing Request

#openssl req -new -newkey rsa:4096 -nodes -keyout "$tmp_path/$im_name".key -subj "$im_subj" -out "$tmp_path/$im_name".csr -config conf_req.config

#openssl rsa -noout -text -in "$tmp_path/$im_name".key
#openssl req -noout -text -in "$tmp_path/$im_name".csr

# Signing a IM's Certificate Signing Request

#openssl ca -in "$tmp_path/$im_name".csr -extensions v3_ca -days "$ca_im_days" -cert "$tmp_path/$ca_name".pem -keyfile "$tmp_path/$ca_name".key -out "$tmp_path/$im_name".crt -batch -config conf_ca.config

#openssl x509 -noout -text -in "$tmp_path/$im_name".crt

# Converting to pem format

#openssl x509 -in "$tmp_path/$im_name".crt -out "$tmp_path/$im_name".der -outform DER
#openssl x509 -in "$tmp_path/$im_name".der -inform DER -out "$tmp_path/$im_name".pem -outform PEM

# Server's private key and Certificate Signing Request

openssl req -new -newkey rsa:4096 -nodes -keyout "$tmp_path/$sr_name".key -subj "$crt_subj" -out "$tmp_path/$sr_name".csr -config conf_req.config

openssl rsa -noout -text -in "$tmp_path/$sr_name".key
openssl req -noout -text -in "$tmp_path/$sr_name".csr

# Signing a server's Certificate Signing Request

openssl ca -in "$tmp_path/$sr_name".csr -extensions v3_req -cert "$tmp_path/$im_name".pem -keyfile "$tmp_path/$im_name".key -out "$tmp_path/$sr_name".crt -batch -config conf_ca.config

openssl x509 -noout -text -in "$tmp_path/$sr_name".crt

# Converting to pem format

openssl x509 -in "$tmp_path/$sr_name".crt -out "$tmp_path/$sr_name".der -outform DER
openssl x509 -in "$tmp_path/$sr_name".der -inform DER -out "$tmp_path/$sr_name".pem -outform PEM

# Concatenate key and cert to one file

cat "$tmp_path/$sr_name".pem "$tmp_path/$sr_name".key "$tmp_path/$im_name".pem "$tmp_path/$ca_name".pem > "$pub_path/$sr_name"_full_chain_with_key.pem
cat  "$tmp_path/$sr_name".pem "$tmp_path/$im_name".pem "$tmp_path/$ca_name".pem > "$pub_path/$sr_name"_full_chain_without_key.pem
cat "$tmp_path/$sr_name".pem "$tmp_path/$im_name".pem "$tmp_path/$ca_name".pem > "$pub_path/$sr_name"_roots_only.pem
cat "$tmp_path/$sr_name".key > "$pub_path/$sr_name".key
cat "$tmp_path/$sr_name".pem > "$pub_path/$sr_name".pem

openssl x509 -noout -text -in "$pub_path/$sr_name".pem

openssl pkcs12 -export -in "$tmp_path/$sr_name".pem -inkey "$tmp_path/$sr_name".key -certfile "$pub_path/$sr_name"_roots_only.pem -out "$pub_path/$sr_name".p12 -passout pass:"$pkcs12_pwd"

