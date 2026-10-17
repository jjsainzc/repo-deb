#!/bin/bash
dpkg-scanpackages --multiversion . /dev/null > Packages
gzip -9c Packages > Packages.gz

SIZE_P=$(stat -c%s Packages)
MD5_P=$(md5sum Packages | cut -d' ' -f1)
SHA256_P=$(sha256sum Packages | cut -d' ' -f1)

SIZE_GZ=$(stat -c%s Packages.gz)
MD5_GZ=$(md5sum Packages.gz | cut -d' ' -f1)
SHA256_GZ=$(sha256sum Packages.gz | cut -d' ' -f1)

DATE=$(date -u +'%a, %d %b %Y %H:%M:%S UTC')

cat <<EOF > Release
Origin: HC1LNM Node
Label: HC1LNM Custom Repo
Suite: stable
Codename: stable
Architectures: amd64 arm64
Components: main
Date: $DATE
MD5Sum:
 $MD5_P $SIZE_P Packages
 $MD5_GZ $SIZE_GZ Packages.gz
SHA256:
 $SHA256_P $SIZE_P Packages
 $SHA256_GZ $SIZE_GZ Packages.gz
EOF

#gpg --batch --yes --clearsign --output InRelease Release
# Cambia "TU_CONTRASEÑA_AQUÍ" por la contraseña real de tu clave GPG
PASSPHRASE="nskdm1153"

gpg --batch --yes --pinentry-mode loopback --passphrase "$PASSPHRASE" --clearsign --output InRelease Release
gpg --batch --yes --pinentry-mode loopback --passphrase "$PASSPHRASE" -abs --output Release.gpg Release


