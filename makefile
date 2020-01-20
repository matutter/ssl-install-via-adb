.RECIPEPREFIX = -
.PHONY: clean

rootdomain  := test.local
rootsubject := "/C=NY/ST=Main St./L=NYC/O=Example/OU=Test/CN=$(rootdomain)"
password    := nopasswd

domain  := test1.$(rootdomain)
subject := "/C=NY/ST=Main St./L=NYC/O=Example/OU=Test/CN=$(domain)"

all: certs/root.pfx certs/$(domain).cer

certs/root.pfx:
- mkdir -p certs
- cd certs && \
  openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -out root.cer -subj $(rootsubject) && \
	openssl pkcs12 -export -out root.pfx -inkey privkey.pem -in root.cer -password pass:$(password) && \
	cp privkey.pem root.pem && \
	touch certindex && \
	echo 01 > serialfile

certs/$(domain).cer:
- cd certs && \
	openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -out root.cer -subj $(subject) && \
	openssl req -newkey rsa:2048 -nodes -out $(domain).csr -keyout $(domain).key -subj $(subject) && \
	cat ../myca.conf > temp.conf && \
	printf "\n[alt_names]\nDNS.1=$(domain)\n" >> temp.conf && \
	openssl ca -md sha512 -batch -config temp.conf -notext -in $(domain).csr -out $(domain).cer && \
	openssl x509 -noout -text -in $(domain).cer && \
	openssl pkcs12 -export -out root.pfx -inkey privkey.pem -in root.cer -password pass:$(password)

clean:
- rm certs/*
- rmdir certs


