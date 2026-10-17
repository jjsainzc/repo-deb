# repo-deb
Repositorio publico de paquetes para Debian ARM/AMD

curl -sSL https://raw.githubusercontent.com/jjsainzc/repo-deb/main/hc1lnm.gpg | sudo gpg --dearmor -o /usr/share/keyrings/hc1lnm-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hc1lnm-archive-keyring.gpg] https://jjsainzc.github.io/repo-deb/ ./ " | sudo tee /etc/apt/sources.list.d/amerinet.list

sudo apt update
sudo apt install serverutil
