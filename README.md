# Repositorio público de paquetes

Paquetes Debian para `amd64` y `arm64`.

## Paquetes

### ServerUtils (`serverutil`)

API REST de desarrollo y administración, implementada en Go/Echo. Expone servicios para AllStarLink, Asterisk y utilidades del servidor; usa MariaDB/MySQL como base de datos relacional. El servicio systemd se llama `serverutils` y escucha en el puerto `8085`.

La base de datos MariaDB/MySQL debe estar creada y accesible antes de usar la API. El paquete instala el esquema en `/etc/serverutils/serverutils.sql` y la configuración en `/etc/serverutils/`; el postinstalador no crea el servidor ni importa automáticamente el esquema.

Documentación de rutas: [Swagger UI](https://www.amerinet-hamradio.net/api/swagger/index.html).

### Amerimon (`amerimon`)

Interfaz web y API para monitorizar AllStarLink, administrar nodos Allmon y escuchar el nodo principal de Asterisk. Usa SQLite local, sin servidor de base de datos adicional. El servicio systemd se llama `amerimon` y escucha en el puerto `8082`; Listen Live usa el puerto local `8086`.

Al instalar, se intenta configurar el proxy de Apache o Nginx para `/amerimon`. Si no hay servidor web, se puede acceder directamente por `http://<IP-del-servidor>:8082/`. En el primer acceso, pulsa **Admin** para crear la cuenta y contraseña iniciales. Para restablecer la contraseña: `sudo amerimon-reset-password`.

## Configuración del repositorio para la instalación de los paquetes

```bash
curl -fsSL https://raw.githubusercontent.com/jjsainzc/repo-deb/main/hc1lnm.gpg \
	| sudo gpg --dearmor --yes -o /usr/share/keyrings/hc1lnm-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hc1lnm-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://jjsainzc.github.io/repo-deb/ ./" \
	| sudo tee /etc/apt/sources.list.d/amerinet.list

sudo apt update
sudo apt install serverutil 
o 
sudo apt install amerimon
```
> <mark><span style="color:red">**NOTA IMPORTANTE**:</span></mark> No se pueden tener las dos aplicaciones en un mismo server porque comparten el puerto del listen-live 


## Actualización y estado

```bash
sudo apt update
sudo apt upgrade
sudo systemctl status serverutils --no-pager
o
sudo systemctl status amerimon --no-pager
```
