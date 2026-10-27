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

> <mark><span style="color:red">**NOTA IMPORTANTE**:</span></mark> No se pueden tener las dos aplicaciones en un mismo server porque comparten el puerto del listen-live.

## Consultar las versiones instaladas y disponibles

Estos comandos se ejecutan por SSH o en una terminal del servidor donde está instalada la aplicación. No requieren detener el servicio.

```bash
# Versión, arquitectura y estado de los paquetes en este servidor:
dpkg-query -W -f='${Package}\t${Version}\t${Architecture}\t${Status}\n' amerimon serverutil

# Otra opción, con información detallada de cada paquete:
dpkg -s amerimon
# O, si usas ServerUtils:
dpkg -s serverutil
```

Consulta el paquete que utilices: si uno no está instalado, `dpkg-query` o `dpkg -s` lo indicará. El estado `install ok installed` confirma que el paquete está instalado; no confirma que el servicio esté funcionando. Para eso utiliza los comandos `systemctl status` de la sección **Actualización y estado**.

Si configuraste el repositorio APT, puedes comparar la versión instalada con la candidata y consultar las versiones que ofrece:

```bash
sudo apt update
apt-cache policy amerimon serverutil
apt-cache madison amerimon serverutil
```

En `apt-cache policy`, **Installed/Instalados** es la versión instalada y **Candidate/Candidato** la que APT instalaría. `apt update` solo actualiza los índices; no instala ni actualiza las aplicaciones. Las versiones disponibles dependen de los repositorios configurados y de la arquitectura del servidor.

## Instalación o actualización manual sin configurar este repositorio APT

No es necesario agregar `amerinet.list` ni importar la clave del repositorio para instalar un archivo `.deb` local. Descarga el paquete desde [los archivos publicados](https://github.com/jjsainzc/repo-deb) o desde [el sitio de paquetes](https://jjsainzc.github.io/repo-deb/), eligiendo la versión y arquitectura correctas.

Si GitHub Pages devuelve `404` para un paquete recién publicado, comprueba que el archivo exista en los archivos publicados y usa su descarga directa desde `raw.githubusercontent.com`. Pages puede no haber terminado de desplegar esa versión. Por ejemplo:

```bash
curl -fLO https://raw.githubusercontent.com/jjsainzc/repo-deb/main/amerimon_1.0.35_linux_amd64.deb
```

```bash
# Arquitectura Debian del servidor: amd64 o arm64.
dpkg --print-architecture
```

Los siguientes ejemplos usan versiones publicadas al redactar esta sección; sustituye la versión por la que quieras instalar. Ejecuta **solo el bloque de la aplicación que utilices**: Amerimon y ServerUtils comparten el puerto Listen Live y no deben instalarse juntos.

### Amerimon

```bash
# Ejemplo para amd64; en arm64 cambia amd64 por arm64 en los nombres de archivo.
curl -fLO https://jjsainzc.github.io/repo-deb/amerimon_1.0.35_linux_amd64.deb

# Revisar el paquete descargado antes de instalarlo:
dpkg-deb --field ./amerimon_1.0.35_linux_amd64.deb Package Version Architecture

sudo apt update
sudo apt install ./amerimon_1.0.35_linux_amd64.deb

# Comprobar la versión instalada y el servicio:
dpkg-query -W -f='${Package}\t${Version}\t${Architecture}\t${Status}\n' amerimon
sudo systemctl status amerimon --no-pager
```

### ServerUtils

```bash
# Ejemplo para amd64; en arm64 cambia amd64 por arm64 en los nombres de archivo.
curl -fLO https://jjsainzc.github.io/repo-deb/serverutil_1.0.117_linux_amd64.deb

# Revisar el paquete descargado antes de instalarlo:
dpkg-deb --field ./serverutil_1.0.117_linux_amd64.deb Package Version Architecture

sudo apt update
sudo apt install ./serverutil_1.0.117_linux_amd64.deb

# El paquete se llama serverutil, pero el servicio se llama serverutils:
dpkg-query -W -f='${Package}\t${Version}\t${Architecture}\t${Status}\n' serverutil
sudo systemctl status serverutils --no-pager
```

El mismo procedimiento sirve para una instalación nueva o para actualizar un paquete ya instalado a una versión más reciente. Antes de actualizar, respalda la configuración y la base de datos de la aplicación; la instalación puede reiniciar el servicio e interrumpir las escuchas.

El prefijo `./` indica a APT que debe instalar el archivo local. APT resuelve las dependencias desde los repositorios Debian configurados: esto evita configurar **este repositorio de aplicaciones**, pero no equivale a una instalación sin Internet. No uses únicamente `dpkg -i` si necesitas que se descarguen las dependencias.

La revisión con `dpkg-deb --field` muestra los metadatos, pero no verifica la autenticidad del archivo. Descarga únicamente desde la fuente oficial mediante HTTPS. Al instalar directamente un `.deb`, no se aplica la verificación del índice firmado de este repositorio APT.

Si no configuras este repositorio, las nuevas versiones de estas aplicaciones no se recibirán automáticamente con `apt upgrade`: tendrás que descargar el nuevo `.deb` y repetir la instalación manual. ServerUtils sigue necesitando MariaDB/MySQL y la preparación del esquema descrita al principio de este documento.

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
