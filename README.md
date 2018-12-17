# Server test certificate generator (linux shell script)
# originally based on https://github.com/ssl-serg/server_cert_gen_with_im 

## Description

It creates server certificate with CA & IM CA root chain: 
<pre>CA -> IM CA -> Server Cert</pre>

## Settings

Look at **create_server_cert.cmd** for configuration details:
<pre>
  set CRT_CA_DAYS=3650
  set CRT_CA_IM_DAYS=3650

  set CRT_CA_SUBJ="/CN=My CA"
  set CRT_CA_IM_SUBJ="/CN=My IM CA"
  set CRT_SUBJ="/C=My/ST=My St/L=My Loc/O=My Org/OU=My OU/CN=myhost.local"

  set CRT_PKCS12_PWD=1234
</pre>

Also, take a look at config_ca.conf and modify alt_names section to your needs.

By default, lines for generating CA cert and Intermediate cert are commented. The script as is is only generating a site script and signing it with CA and IM. If you have no CA and IM certs, just uncomment corresponding lines.
