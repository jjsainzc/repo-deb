#!/usr/bin/env bash
# Genera un repositorio APT en ./public a partir de los .deb de ./pool
# Firma opcional: exporta GPG_PRIVATE_KEY (armored) y opcionalmente GPG_PASSPHRASE.
set -euo pipefail
cd "$(dirname "$0")/.."

SUITE=stable
COMP=main
ARCHS="amd64 arm64"
OUT=public

rm -rf "$OUT"
mkdir -p "$OUT/pool"
find pool -name '*.deb' -exec cp {} "$OUT/pool/" \;

for arch in $ARCHS; do
  d="$OUT/dists/$SUITE/$COMP/binary-$arch"
  mkdir -p "$d"
  (cd "$OUT" && dpkg-scanpackages --arch "$arch" pool /dev/null) > "$d/Packages"
  gzip -9kf "$d/Packages"
done

apt-ftparchive \
  -o APT::FTPArchive::Release::Origin="repo-deb" \
  -o APT::FTPArchive::Release::Label="repo-deb" \
  -o APT::FTPArchive::Release::Suite="$SUITE" \
  -o APT::FTPArchive::Release::Codename="$SUITE" \
  -o APT::FTPArchive::Release::Architectures="$ARCHS" \
  -o APT::FTPArchive::Release::Components="$COMP" \
  release "$OUT/dists/$SUITE" > "$OUT/dists/$SUITE/Release"

if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
  export GNUPGHOME="$(mktemp -d)"
  echo "$GPG_PRIVATE_KEY" | gpg --batch --import
  gpg_args=(--batch --yes --pinentry-mode loopback)
  [ -n "${GPG_PASSPHRASE:-}" ] && gpg_args+=(--passphrase "$GPG_PASSPHRASE")
  gpg "${gpg_args[@]}" --armor --detach-sign -o "$OUT/dists/$SUITE/Release.gpg" "$OUT/dists/$SUITE/Release"
  gpg "${gpg_args[@]}" --clearsign -o "$OUT/dists/$SUITE/InRelease" "$OUT/dists/$SUITE/Release"
  gpg --batch --export > "$OUT/repo-deb.gpg"
  gpg --batch --armor --export > "$OUT/repo-deb.asc"
else
  echo "Aviso: sin GPG_PRIVATE_KEY, el repositorio no se firma (usar [trusted=yes])." >&2
fi
