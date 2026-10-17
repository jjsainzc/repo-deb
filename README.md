# repo-deb
Repositorio público de paquetes para Debian ARM/AMD (amd64 y arm64).

## Añadir paquetes
Copia los `.deb` en `pool/` y haz push a `main`. El workflow
`.github/workflows/publish.yml` genera el índice APT (`scripts/build-repo.sh`)
y lo publica en GitHub Pages (activar Settings → Pages → Source: GitHub Actions).

## Firma (recomendado)
Añade los secretos `GPG_PRIVATE_KEY` (clave armored) y, si procede, `GPG_PASSPHRASE`.

## Uso en el cliente
Con firma:
```
curl -fsSL https://jjsainzc.github.io/repo-deb/repo-deb.gpg | sudo tee /usr/share/keyrings/repo-deb.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/repo-deb.gpg] https://jjsainzc.github.io/repo-deb stable main" | sudo tee /etc/apt/sources.list.d/repo-deb.list
sudo apt update
```
Sin firma: usar `deb [trusted=yes] https://jjsainzc.github.io/repo-deb stable main`.

## Generar localmente
`./scripts/build-repo.sh` crea el repositorio en `public/`.
