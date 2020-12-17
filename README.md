# Concurrent Weather Queries

> Consulta el clima de las ciudades de origen y destino de tickets de aeropuertos, utilizando la API de OpenWeatherMap.
> Realiza consultas concurrentemente, limitando las solicitudes a la API y utilizando una caché.

## Instalación y ejecución (Docker)
Recomendamos utilizar *Docker* para instalar el proyecto, o el manejador de versiones *asdf*. No obstante, también es posible realizar la instalación manual, utilizando los repositorios oficiales de cada sistema operativo, aunque esto es propenso a incompatibilidades.

## Docker
Es posible utilizar Docker para simplificar la instalación de Erlang y Elixir.  
Para esto, proveemos el archivo [Dockerfile](Dockerfile).  
Para instalar Docker, recomendamos seguir las [guías oficiales](https://docs.docker.com/get-docker/).
Una vez teniendo Docker instalado, podemos ejecutar los siguientes comandos:
```bash
# Construye el contenedor y compila el proyecto.
docker build -t webservice .

# Ejecuta el proyecto
docker run webservice
```
Esto va a ejecutar el proyecto, utilizando los archivos `dataset1.csv` y `dataset2.csv`, que se encuentran en la carpeta `priv`.

## Instalación y ejecución (asdf)
El programa fue desarrollado y testeado en *Elixir 1.10.4 (OTP 23.0.4)*.  
### asdf
Recomendamos utilizar [asdf](https://asdf-vm.com/) para la instalación y para asegurar que no hay incompatibilidad de versiones. [Instrucciones para instalar asdf](https://asdf-vm.com/#/core-manage-asdf).  
#### Ubuntu
Instalar los pre-requisitos de erlang:
```bash
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
```
Instalación de erlang:
```bash
# Instrucciones en: https://github.com/asdf-vm/asdf-erlang
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 23.0.4
asdf global erlang 23.0.4
```
Instalación de elixir:
```bash
sudo apt-get install unzip
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
# Es necesario que concuerde con la versión OTP
asdf install elixir 1.10.4-otp-23
asdf global elixir 1.10.4-otp-23 
```
Para ver la versión instalada en el sistema se puede ejecutar el comando `iex --version`.

#### Otros sistemas operativos
- [Instrucciones para instalar Erlang.](https://github.com/asdf-vm/asdf-erlang#before-asdf-install)
- [Instrucciones para instalar Elixir.](https://github.com/asdf-vm/asdf-elixir#install)


### Compilación
Primero es necesario instalar las dependencias del proyecto:
```bash
mix deps.get
```
Posteriormente, podemos compilar el proyecto utilizando el comando:
```bash
# Primero ejecutar:
mix compile
# Luego, ejecutar:
mix run_project
```
El primer comando compilará el proyecto, y el segundo comando ejecutará el proyecto.

### Testing
Para correr las pruebas unitarias:
```bash
mix test
```

### Ejecución
Tras haber compilado el proyecto, con las instrucciones de antes, se habrá generado el archivo ejecutable `webservice`. Este puede ejecutarse como cualquier programa de linux, únicamente llamándolo desde bash de la siguiente manera:
```
./webservice
```
Esto va a ejecutar el proyecto, utilizando los archivos `dataset1.csv` y `dataset2.csv`, que se encuentran en la carpeta `priv`.

## Autores
- Fausto David Hernández Jasso - <fausto.david.hernandez.jasso@ciencias.unam.mx> - [GitHub](https://github.com/faustodavidhernandezjasso/)
- Juan Pablo Yamamoto Zazueta -  <jpyamamoto@ciencias.unam.mx> -  [GitHub](https://github.com/JPYamamoto/)
