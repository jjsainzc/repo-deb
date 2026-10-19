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
```

## Instalar la primera vez después de configurar el repositorio

<div style="background-color: #1e1e1e; color: #d4d4d4; border-left: 5px solid #007acc; padding: 15px; border-radius: 6px; margin-bottom: 10px; font-family: monospace;">
  <span style="color: #6a9955;"># Actualizar repositorios:</span><br>
  <span style="color: #4ec9b0;">sudo</span> apt update<br><br>
  <span style="color: #6a9955;"># Instalar paquete principal (servidor):</span><br>
  <span style="color: #4ec9b0;">sudo</span> apt install serverutil<br><br>
  <span style="color: #6a9955;"># O alternativamente para la interfaz/monitoreo:</span><br>
  <span style="color: #4ec9b0;">sudo</span> apt install amerimon
</div>

> <mark><span style="color:red">**NOTA IMPORTANTE**:</span></mark> No se pueden tener las dos aplicaciones en un mismo server porque comparten el puerto del listen-live 


## Actualización y estado

<div style="background-color: #1e1e1e; color: #d4d4d4; border-left: 5px solid #007acc; padding: 15px; border-radius: 6px; margin-bottom: 10px; font-family: monospace;">
  <span style="color: #6a9955;"># Actualizar repositorios y paquetes:</span><br>
  <span style="color: #4ec9b0;">sudo</span> apt update<br>
  <span style="color: #4ec9b0;">sudo</span> apt upgrade<br><br>
  <span style="color: #6a9955;"># Verificar estado del servicio del servidor:</span><br>
  <span style="color: #4ec9b0;">sudo</span> systemctl status serverutils --no-pager<br><br>
  <span style="color: #6a9955;"># O verificar estado del servicio de monitoreo/interfaz:</span><br>
  <span style="color: #4ec9b0;">sudo</span> systemctl status amerimon --no-pager
</div>
