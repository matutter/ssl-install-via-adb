## Usage

### Generate the certificate

```bash
make
```

### Update /etc/hosts

The following scripts will update `/etc/hosts` and setup a reverse proxy.

```bash
./install.sh
./reverse.sh
```

### Install certificate

Use `nopasswd` as the password when prompted.

```bash
make
adb push /certs/root.pfx /sdcard/Downloads
```

Install certs/root.pfx on device via UI by going to `Settings > Security`
under the `Credential Storage` section click `Install from Storage` and
navigate to the `Downloads` folder. Use `nopasswd` to install the CA.

Finally `test1.example.com` may pe installed in NGINX.

### Uninstall changes

```bash
install restore
```

### Test with `wget`

```bash
adb shell /data/local/tmp/busybox wget -c -P /data/local/tmp -S https://test1.test.local:8443
```

Installing the certificate from the gui will likely install the certificate in
this path: `/data/misc/keystore/user_0/*`. Where is will be broken up into
CACERT, USRCERT, USRPKEY parts.
